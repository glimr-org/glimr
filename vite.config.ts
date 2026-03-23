import { defineConfig, type Plugin } from "vite";
import tailwindcss from "@tailwindcss/vite";
import { resolve } from "path";
import { mkdirSync, writeFileSync, unlinkSync } from "fs";
import type { AddressInfo } from "net";

/**
 * Writes a `priv/static/hot` file containing the dev server URL
 * so the framework's vite module can detect dev mode and emit
 * tags pointing at Vite's HMR server instead of the manifest.
 */
function hotFile(): Plugin {
  const hotPath = resolve("priv/static/hot");
  const cleanup = () => {
    try {
      unlinkSync(hotPath);
    } catch {}
  };

  return {
    name: "glimr-hot-file",
    buildStart() {
      cleanup();
    },
    configureServer(server) {
      server.httpServer?.once("listening", () => {
        const addr = server.httpServer!.address() as AddressInfo;
        mkdirSync(resolve("priv/static"), { recursive: true });
        writeFileSync(hotPath, `http://localhost:${addr.port}`);

        process.on("exit", cleanup);
        process.on("SIGINT", () => process.exit());
        process.on("SIGTERM", () => process.exit());
      });
    },
  };
}

/**
 * Watches for the `.reload` trigger file written by Glimr's
 * watcher after successful compilation. Sends a full page
 * reload to the browser through Vite's HMR WebSocket.
 */
function glimrReload(): Plugin {
  const reloadPath = resolve("priv/static/.reload");
  return {
    name: "glimr-reload",
    configureServer(server) {
      server.watcher.add(reloadPath);
      server.watcher.on("change", (path) => {
        if (path === reloadPath) {
          server.ws.send({ type: "full-reload" });
        }
      });
    },
    handleHotUpdate({ file }) {
      if (file.endsWith(".loom.html")) {
        return [];
      }
    },
  };
}

export default defineConfig({
  plugins: [tailwindcss(), hotFile(), glimrReload()],
  resolve: {
    alias: {
      "@": resolve(import.meta.dirname!, "src/resources/ts"),
    },
  },
  build: {
    outDir: "priv/static",
    emptyOutDir: false,
    manifest: true,
    rollupOptions: {
      input: "src/resources/ts/app.ts",
    },
  },
  server: {
    cors: true,
    watch: {
      ignored: ["**/*.gleam", "**/build/**"],
    },
  },
});
