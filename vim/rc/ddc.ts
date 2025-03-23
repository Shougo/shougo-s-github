import { BaseConfig, ConfigArguments } from "jsr:@shougo/ddc-vim@~9.4.0/config";
import type { DdcItem } from "jsr:@shougo/ddc-vim@~9.4.0/types";

import type { Denops } from "jsr:@denops/std@~7.5.0";
import * as fn from "jsr:@denops/std@~7.5.0/function";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const hasNvim = args.denops.meta.host === "nvim";
    const hasWindows = await fn.has(args.denops, "win32");

    const commonSources = [
      "around",
      "file",
      //"codeium",
      //"copilot",
    ];

    const mocWord = Deno.env.get("MOCWORD_DATA") ? ["mocword"] : [];

    args.contextBuilder.patchGlobal({
      ui: "pum",
      dynamicUi: async (denops: Denops, args: Record<string, unknown>) => {
        const uiArgs = args as {
          items: DdcItem[];
        };
        const mode = await fn.mode(denops);
        return Promise.resolve(
          mode !== "t" && uiArgs.items.length == 1 ? "inline" : "pum",
        );
      },
      autoCompleteEvents: [
        "CmdlineEnter",
        "CmdlineChanged",
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "TextChangedT",
      ],
      sources: commonSources,
      cmdlineSources: {
        ":": ["cmdline", "cmdline_history", "around"],
        "@": ["input", "cmdline_history", "file", "around"],
        ">": ["input", "cmdline_history", "file", "around"],
        "/": ["around", "line"],
        "?": ["around", "line"],
        "-": ["around", "line"],
        "=": ["input"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: [
            "matcher_head",
            "matcher_prefix",
            "matcher_length",
          ],
          sorters: ["sorter_rank"],
          converters: ["converter_remove_overlap"],
          timeout: 1000,
        },
        around: {
          mark: "A",
        },
        buffer: {
          mark: "B",
        },
        cmdline: {
          isVolatile: true,
          mark: "cmdline",
          matchers: [
            "matcher_length",
          ],
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
        },
        cmdline_history: {
          mark: "history",
          sorters: [],
        },
        codeium: {
          mark: "cod",
          matchers: ["matcher_length"],
          minAutoCompleteLength: 0,
          isVolatile: true,
        },
        copilot: {
          mark: "cop",
          matchers: [],
          minAutoCompleteLength: 0,
          isVolatile: false,
        },
        file: {
          mark: "F",
          isVolatile: true,
          minAutoCompleteLength: 1000,
          forceCompletionPattern: "\\S/\\S*",
        },
        input: {
          mark: "input",
          forceCompletionPattern: "\\S/\\S*",
          isVolatile: true,
        },
        line: {
          mark: "line",
        },
        lsp: {
          mark: "lsp",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
        },
        mocword: {
          mark: "mocword",
          minAutoCompleteLength: 4,
          isVolatile: true,
        },
        rg: {
          mark: "rg",
          minAutoCompleteLength: 5,
          enabledIf: "finddir('.git', ';') != ''",
        },
        rtags: {
          mark: "R",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
        },
        shell: {
          mark: "sh",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
          minAutoCompleteLength: 3,
        },
        shell_history: {
          mark: "history",
          sorters: [],
        },
        shell_native: {
          mark: "sh",
          forceCompletionPattern: "\\S/\\S*",
          minAutoCompleteLength: 3,
        },
        skkeleton: {
          mark: "skk",
          matchers: [],
          sorters: [],
          minAutoCompleteLength: 2,
          isVolatile: true,
        },
        vim: {
          mark: "vim",
          isVolatile: true,
        },
        yank: {
          mark: "Y",
        },
      },
      sourceParams: {
        buffer: {
          requireSameFiletype: false,
          limitBytes: 50000,
          fromAltBuf: true,
          forceCollect: true,
        },
        file: {
          filenameChars: "[:keyword:].",
        },
        lsp: {
          enableAdditionalTextEdit: true,
          enableDisplayDetail: true,
          enableMatchLabel: true,
          enableResolveItem: true,
        },
        shell_history: {
          paths: ["~/.cache/ddt-shell-history", "~/.zsh-history"],
        },
        shell_native: {
          shell: "zsh",
        },
      },
      postFilters: ["sorter_head"],
    });

    for (
      const filetype of [
        "markdown",
        "markdown_inline",
        "gitcommit",
        "comment",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: commonSources.concat(["line"]).concat(mocWord),
      });
    }

    for (const filetype of ["html", "css"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "[0-9a-zA-Z_:#-]*",
          },
        },
      });
    }

    const shellSourceOptions = {
      specialBufferCompletion: true,
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_./#:-]*",
        },
      },
      sources: [
        hasWindows ? "shell" : "shell_native",
        "shell_history",
        "around",
      ],
    };
    for (
      const filetype of [
        "zsh",
        "sh",
        "bash",
        "ddt-shell",
        "ddt-terminal",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, shellSourceOptions);
    }

    // Use "#" as TypeScript keywordPattern
    for (const filetype of ["typescript"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "#?[a-zA-Z_][0-9a-zA-Z_]*",
          },
        },
      });
    }

    if (hasNvim) {
      for (
        const filetype of [
          "css",
          "go",
          "graphql",
          "html",
          "lua",
          "python",
          "ruby",
          "rust",
          "tsx",
          "typescript",
          "typescriptreact",
        ]
      ) {
        args.contextBuilder.patchFiletype(filetype, {
          sources: ["lsp"].concat(commonSources),
        });
      }
    }

    args.contextBuilder.patchFiletype("vim", {
      // Enable specialBufferCompletion for cmdwin.
      specialBufferCompletion: true,
      sources: ["vim", "cmdline"].concat(commonSources),
    });
  }
}
