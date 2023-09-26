import { BaseConfig, Dpp, Plugin } from "https://deno.land/x/dpp_vim@v0.0.0/types.ts";
import { Denops } from "https://deno.land/x/dpp_vim@v0.0.0/deps.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    basePath: string;
    dpp: Dpp;
  }): Promise<{
    plugins: Plugin[];
    stateLines: string[];
  }> {
    let plugins: Plugin[] = [];

    plugins = plugins.concat(
      await args.dpp.extAction(args.denops, "local", "local", {
        directory: "~/work",
        options: {
          frozen: true,
          merged: false,
        },
        includes: [
          "vim*",
          "nvim-*",
          "*.vim",
          "*.nvim",
          "ddc-*",
          "ddu-*",
          "skkeleton",
          "neco-vim",
        ],
      }) as Plugin[],
    );

    plugins = plugins.concat(
      await args.dpp.extAction(args.denops, "toml", "load", {
        path: "$BASE_DIR/dein.toml",
        options: {
          lazy: true,
        },
      }) as Plugin[],
    );

    const stateLines = await args.dpp.extAction(
      args.denops,
      "lazy",
      "makeState",
    );

    return {
      plugins,
      stateLines,
    };
  }
}
