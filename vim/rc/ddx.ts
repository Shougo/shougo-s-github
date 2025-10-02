import { BaseConfig, ConfigArguments } from "@shougo/ddx-vim/config";

export class Config extends BaseConfig {
  override config(args: ConfigArguments): void {
    args.contextBuilder.patchGlobal({
      ui: "hex",
      analyzers: ["zip"],
    });
  }
}
