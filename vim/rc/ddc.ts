import { BaseConfig } from "https://deno.land/x/ddc_vim@v3.9.0/types.ts";
import { fn } from "https://deno.land/x/ddc_vim@v3.9.0/deps.ts";
import { ConfigArguments } from "https://deno.land/x/ddc_vim@v3.9.0/base/config.ts";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const hasNvim = args.denops.meta.host === "nvim";
    const hasWindows = await fn.has(args.denops, "win32");

    args.contextBuilder.patchGlobal({
      ui: "pum",
      sources: ["codeium", "around", "file"],
      autoCompleteEvents: [
        "InsertEnter",
        "TextChangedI",
        "TextChangedP",
        "CmdlineEnter",
        "CmdlineChanged",
        "TextChangedT",
      ],
      cmdlineSources: {
        ":": ["cmdline", "cmdline-history", "around"],
        "@": ["input", "cmdline-history", "file", "around"],
        ">": ["input", "cmdline-history", "file", "around"],
        "/": ["around", "line"],
        "?": ["around", "line"],
        "-": ["around", "line"],
        "=": ["input"],
      },
      sourceOptions: {
        _: {
          ignoreCase: true,
          matchers: ["matcher_head", "matcher_prefix", "matcher_length"],
          sorters: ["sorter_rank"],
          converters: [
            "converter_remove_overlap",
            "converter_truncate_abbr",
          ],
          timeout: 1000,
        },
        around: {
          mark: "A",
        },
        buffer: {
          mark: "B",
        },
        necovim: {
          mark: "vim",
        },
        "nvim-lua": {
          mark: "lua",
          forceCompletionPattern: "\\.\\w*",
        },
        cmdline: {
          mark: "cmdline",
          forceCompletionPattern: "\\S/\\S*|\\.\\w*",
        },
        copilot: {
          mark: "cop",
          matchers: [],
          minAutoCompleteLength: 0,
          isVolatile: false,
        },
        codeium: {
          mark: "cod",
          matchers: ["matcher_length"],
          minAutoCompleteLength: 0,
          isVolatile: true,
        },
        input: {
          mark: "input",
          forceCompletionPattern: "\\S/\\S*",
          isVolatile: true,
        },
        line: {
          mark: "line",
          matchers: ["matcher_vimregexp"],
        },
        mocword: {
          mark: "mocword",
          minAutoCompleteLength: 4,
          isVolatile: true,
        },
        "nvim-lsp": {
          mark: "lsp",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
          dup: "force",
        },
        rtags: {
          mark: "R",
          forceCompletionPattern: "\\.\\w*|::\\w*|->\\w*",
        },
        file: {
          mark: "F",
          isVolatile: true,
          minAutoCompleteLength: 1000,
          forceCompletionPattern: "\\S/\\S*",
        },
        "cmdline-history": {
          mark: "history",
          sorters: [],
        },
        "shell-history": {
          mark: "history",
        },
        shell: {
          mark: "sh",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        "shell-native": {
          mark: "sh",
          isVolatile: true,
          forceCompletionPattern: "\\S/\\S*",
        },
        rg: {
          mark: "rg",
          minAutoCompleteLength: 5,
          enabledIf: "finddir('.git', ';') != ''",
        },
        skkeleton: {
          mark: "skk",
          matchers: ["skkeleton"],
          sorters: [],
          minAutoCompleteLength: 2,
          isVolatile: true,
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
        "shell-native": {
          shell: "fish",
        },
      },
    });

    for (
      const filetype of [
        "help",
        "vimdoc",
        "markdown",
        "gitcommit",
        "comment",
      ]
    ) {
      args.contextBuilder.patchFiletype(filetype, {
        sources: ["around", "codeium", "mocword"],
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

    for (const filetype of ["zsh", "sh", "bash"]) {
      args.contextBuilder.patchFiletype(filetype, {
        sourceOptions: {
          _: {
            keywordPattern: "[0-9a-zA-Z_./#:-]*",
          },
        },
        sources: [
          hasWindows ? "shell" : "shell-native", "around",
        ],
      });
    }
    args.contextBuilder.patchFiletype("deol", {
      specialBufferCompletion: true,
      sources: [
        hasWindows ? "shell" : "shell-native", "shell-history", "around",
      ],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_./#:-]*",
        },
      },
    });

    args.contextBuilder.patchFiletype("ddu-ff-filter", {
      sources: ["line", "buffer"],
      sourceOptions: {
        _: {
          keywordPattern: "[0-9a-zA-Z_:#-]*",
        },
      },
      specialBufferCompletion: true,
    });

    if (hasNvim) {
      for (
        const filetype of [
          "css",
          "go",
          "html",
          "python",
          "ruby",
          "typescript",
          "typescriptreact",
        ]
      ) {
        args.contextBuilder.patchFiletype(filetype, {
          sources: ["codeium", "nvim-lsp", "around"],
        });
      }

      args.contextBuilder.patchFiletype("lua", {
        sources: ["codeium", "nvim-lsp", "nvim-lua", "around"],
      });

      // Enable specialBufferCompletion for cmdwin.
      args.contextBuilder.patchFiletype("vim", {
        specialBufferCompletion: true,
      });
    }
  }
}
