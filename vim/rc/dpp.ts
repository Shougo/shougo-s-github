import { BaseConfig } from "https://deno.land/x/ddc_vim@v4.0.4/types.ts";
import { Denops } from "https://deno.land/x/ddc_vim@v4.0.4/deps.ts";

export class Config extends BaseConfig {
  override async config(args: {
    denops: Denops;
    basePath: string;
    dpp: Dpp;
  }): Promise<Plugin[]> {
    let plugins: Plugin[] = []

    plugins = plugins.concat(await args.dpp.extAction(args.denops, "local", "local", {
      directory: "~/work",
      options: {
        frozen: true,
        merged: false,
      },
      includes: [
        "vim*", "nvim-*", "*.vim", "*.nvim",
        "ddc-*", "ddu-*",
        "skkeleton", "neco-vim",
      ],
    }));

    plugins = plugins.concat(await args.dpp.extAction(args.denops, "toml", "load", {
      path: "$BASE_DIR/dein.toml",
      options: {
        lazy: true,
      },
    }));

    console.log(plugins);

    return plugins;
  }
}
