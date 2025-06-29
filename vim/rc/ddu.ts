import {
  type ActionArguments,
  ActionFlags,
  type DduOptions,
} from "jsr:@shougo/ddu-vim@~10.3.0/types";
import {
  BaseConfig,
  type ConfigArguments,
} from "jsr:@shougo/ddu-vim@~10.3.0/config";
import type { ActionData as FileAction } from "jsr:@shougo/ddu-kind-file@~0.9.0";
import type { Params as FfParams } from "jsr:@shougo/ddu-ui-ff@~2.0.0";
import type { Params as FilerParams } from "jsr:@shougo/ddu-ui-filer@~2.0.0";

import type { Denops } from "jsr:@denops/std@~7.6.0";
import * as fn from "jsr:@denops/std@~7.6.0/function";

type Params = Record<string, unknown>;

type DppAction = {
  path: string;
  __name: string;
};

export class Config extends BaseConfig {
  override config(args: ConfigArguments): Promise<void> {
    args.setAlias("_", "source", "file_rg", "file_external");
    args.setAlias("_", "source", "file_git", "file_external");
    args.setAlias(
      "_",
      "filter",
      "matcher_ignore_current_buffer",
      "matcher_ignores",
    );
    args.setAlias("_", "action", "tabopen", "open");

    args.contextBuilder.patchGlobal({
      ui: "ff",
      profile: false,
      uiOptions: {
        _: {
          filterInputFunc: "cmdline#input",
          filterInputOptsFunc: "cmdline#input_opts",
        },
        ff: {
          actions: {
            kensaku: async (args: {
              denops: Denops;
              options: DduOptions;
            }) => {
              await args.denops.dispatcher.updateOptions(
                args.options.name,
                {
                  sourceOptions: {
                    _: {
                      matchers: ["matcher_kensaku"],
                    },
                  },
                },
              );
              await args.denops.cmd("echomsg 'change to kensaku matcher'");

              return ActionFlags.Persist;
            },
          },
        },
        filer: {
          toggle: true,
        },
      },
      uiParams: {
        ff: {
          autoAction: {
            name: "preview",
          },
          filterSplitDirection: "floating",
          floatingBorder: "none",
          highlights: {
            filterText: "Statement",
            floating: "Normal",
            floatingBorder: "Special",
          },
          maxHighlightItems: 50,
          onPreview: async (args: {
            denops: Denops;
            previewWinId: number;
          }) => {
            await fn.win_execute(args.denops, args.previewWinId, "normal! zt");
          },
          previewFloating: true,
          previewFloatingBorder: "single",
          //previewSplit: "no",
          updateTime: 0,
          winWidth: 100,
        } as Partial<FfParams>,
        filer: {
          autoAction: {
            name: "preview",
          },
          previewCol: "&columns / 2 + 1",
          previewFloating: true,
          sort: "filename",
          sortTreesFirst: true,
          split: "no",
          //startAutoAction: true,
          toggle: true,
        } as Partial<FilerParams>,
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_substring"],
          smartCase: true,
        },
        file_old: {
          matchers: [
            "matcher_relative",
            "matcher_substring",
          ],
          converters: ["converter_hl_dir"],
        },
        file_git: {
          matchers: [
            "matcher_relative",
            "matcher_substring",
          ],
          sorters: ["sorter_mtime"],
          converters: ["converter_hl_dir"],
        },
        file_rec: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          sorters: ["sorter_mtime"],
          converters: ["converter_hl_dir"],
        },
        file: {
          matchers: [
            "matcher_substring",
            "matcher_hidden",
          ],
          sorters: ["sorter_alpha"],
          converters: ["converter_hl_dir"],
        },
        dpp: {
          defaultAction: "cd",
          actions: {
            update: {
              description: "Update the plugins.",
              callback: async (args: ActionArguments<Params>) => {
                const names = args.items.map((item) =>
                  (item.action as DppAction).__name
                );

                await args.denops.call(
                  "dpp#async_ext_action",
                  "installer",
                  "update",
                  { names },
                );

                return Promise.resolve(ActionFlags.None);
              },
            },
          },
        },
        command_args: {
          defaultAction: "execute",
        },
        markdown: {
          sorters: [],
        },
        line: {
          matchers: [
            "matcher_kensaku",
          ],
        },
        path_history: {
          defaultAction: "uiCd",
        },
        rg: {
          matchers: [
            "matcher_substring",
            "matcher_files",
          ],
        },
        ddt_shell_history: {
          defaultAction: "execute",
        },
      },
      sourceParams: {
        file_git: {
          cmd: ["git", "ls-files", "-co", "--exclude-standard"],
        },
        rg: {
          args: [
            "--smart-case",
            "--column",
            "--no-heading",
            "--color",
            "never",
          ],
        },
        file_rg: {
          cmd: [
            "rg",
            "--files",
            "--glob",
            "!.git",
            "--color",
            "never",
            "--no-messages",
          ],
          updateItems: 50000,
        },
        ddt_shell_history: {
          paths: ["~/.cache/ddt-shell-history", "~/.zsh-history"],
        },
      },
      filterParams: {
        matcher_kensaku: {
          highlightMatched: "PmenuMatch",
        },
        matcher_substring: {
          highlightMatched: "PmenuMatch",
        },
        matcher_ignore_files: {
          ignoreGlobs: ["test_*.vim"],
          ignorePatterns: [],
        },
        converter_hl_dir: {
          hlGroup: ["Directory", "Keyword"],
        },
      },
      kindOptions: {
        file: {
          defaultAction: "open",
          actions: {
            grep: {
              description: "Grep from the path.",
              callback: async (args: ActionArguments<Params>) => {
                const action = args.items[0]?.action as FileAction;

                await args.denops.call("ddu#start", {
                  name: args.options.name,
                  push: true,
                  sources: [
                    {
                      name: "rg",
                      params: {
                        path: action.path,
                        input: await fn.input(args.denops, "Pattern: "),
                      },
                    },
                  ],
                });

                return Promise.resolve(ActionFlags.None);
              },
            },
          },
        },
        word: {
          defaultAction: "append",
        },
        ddt_tab: {
          defaultAction: "switch",
        },
        action: {
          defaultAction: "do",
        },
        readme_viewer: {
          defaultAction: "open",
        },
        url: {
          defaultAction: "browse",
        },
      },
      kindParams: {
        file: {
          trashCommand: ["gtrash", "put"],
        },
      },
      actionOptions: {
        narrow: {
          quit: false,
        },
        tabopen: {
          quit: false,
        },
      },
      actionParams: {
        tabopen: {
          command: "tabedit",
        },
      },
    });

    // Register my source.
    //args.denops.dispatcher.registerExtension(
    //  "default",
    //  "source",
    //  "myfile",
    //  new MySource(),
    //);

    return Promise.resolve();
  }
}
