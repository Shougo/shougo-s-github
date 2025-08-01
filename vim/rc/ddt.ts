import { BaseConfig, ConfigArguments } from "@shougo/ddt-vim/config";

import * as fn from "@denops/std/function";

export class Config extends BaseConfig {
  override async config(args: ConfigArguments): Promise<void> {
    const hasWindows = await fn.has(args.denops, "win32");

    args.contextBuilder.patchGlobal({
      debug: false,
      nvimServer: "~/.cache/nvim/server.pipe",
      uiParams: {
        shell: {
          aliases: {
            ls: "ls --color",
          },
          ansiColorHighlights: {
            bgs: [
              "TerminalBG0",
              "TerminalBG1",
              "TerminalBG2",
              "TerminalBG3",
              "TerminalBG4",
              "TerminalBG5",
              "TerminalBG6",
              "TerminalBG7",
              "TerminalBG8",
              "TerminalBG9",
              "TerminalBG10",
              "TerminalBG11",
              "TerminalBG12",
              "TerminalBG13",
              "TerminalBG14",
              "TerminalBG15",
            ],
            bold: "Bold",
            fgs: [
              "TerminalFG0",
              "TerminalFG1",
              "TerminalFG2",
              "TerminalFG3",
              "TerminalFG4",
              "TerminalFG5",
              "TerminalFG6",
              "TerminalFG7",
              "TerminalFG8",
              "TerminalFG9",
              "TerminalFG10",
              "TerminalFG11",
              "TerminalFG12",
              "TerminalFG13",
              "TerminalFG14",
              "TerminalFG15",
            ],
            italic: "Italic",
            underline: "Underlined",
          },
          noSaveHistoryCommands: [
            "history",
          ],
          userPrompt: "'| ' .. fnamemodify(getcwd(), ':~') .. MyGitStatus()",
          shellHistoryPath: "~/.cache/ddt-shell-history",
        },
        terminal: {
          command: ["zsh"],
          promptPattern: hasWindows ? "\f\+>" : "\w*% \?",
        },
      },
    });
  }
}
