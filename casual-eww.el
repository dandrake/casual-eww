;;; casual-eww.el --- Transient UI for EWW -*- lexical-binding: t; -*-

;; Copyright (C) 2024 Claude (Anthropic)

;; Author: Claude <noreply@anthropic.com>
;; URL: https://github.com/kickingvegas/casual-suite
;; Keywords: tools
;; Version: 2.0.0
;; Package-Requires: ((emacs "29.1") (casual-lib "1.1.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Casual EWW is an opinionated Transient-based porcelain for the Emacs Web
;; Wowser (EWW), providing an intuitive menu interface for web browsing within
;; Emacs.

;; INSTALLATION
;; (require 'casual-eww)
;; (keymap-set eww-mode-map "C-o" #'casual-eww-tmenu)

;;; Code:
(require 'eww)
(require 'transient)
(require 'casual-lib)

;;; Transient Menus

(transient-define-prefix casual-eww-tmenu ()
  "Casual EWW main menu."
  [["Link Nav"
    ("G" "Open URL…" eww :transient nil)
    ("l" "Back" eww-back-url :transient nil)
    ("r" "Forward" eww-forward-url :transient nil)
    ("H" "History" eww-list-histories :transient nil)]

   ["Page Nav"
    ("SPC" "scroll ↓" scroll-down-command :transient t)
    ("DEL" "scroll ↑" scroll-up-command :transient t)
    ("<" "page top" beginning-of-buffer :transient t)
    (">" "page end" end-of-buffer :transient t)
    ("g" "Reload" eww-reload :transient nil)
    ]

   ["Site Nav"
    ("n" "Next URL" eww-next-url :transient nil)
    ("p" "Previous URL" eww-previous-url :transient nil)
    ("t" "Top URL" eww-top-url :transient nil)
    ("u" "Up URL" eww-up-url :transient nil)]

   ["Links"
    ("TAB" "Next Link" shr-next-link :transient t)
    ("DEL" "Previous Link" shr-previous-link :transient t)
    ("RET" "Open in New Buffer" eww-open-in-new-buffer :transient nil)
    ("w" "Copy URL" eww-copy-page-url :transient t)
    ("A" "Copy Alternate URL" eww-copy-alternate-url :transient t)]]

  [["View"
    ("R" "Readable Mode" eww-readable :transient t)
    ("F" "Toggle Fonts" eww-toggle-fonts :transient t)
    ("C" "Toggle Colors" eww-toggle-colors :transient t)
    ("I" "Toggle Images" eww-toggle-images :transient t)
    ("v" "View Source" eww-view-source :transient nil)]

   ["Actions"
    ("o" "Copy as org markup" org-eww-copy-for-org-mode :transient nil )
    ("d" "Download" eww-download :transient nil)
    ("&" "External Browser" eww-browse-with-external-browser :transient nil)]

   ["Bookmarks & Buffers"
    ("b" "Add Bookmark" eww-add-bookmark :transient t)
    ("B" "List Bookmarks" eww-list-bookmarks :transient nil)
    ("S" "List Buffers" eww-list-buffers :transient nil)
    ("s" "Switch Buffer" eww-switch-to-buffer :transient nil)]]

  [["Utility"
    ("?" "Describe Mode" describe-mode :transient nil)
    ("E" "Set Encoding" eww-set-character-encoding :transient t)
    ("D" "Toggle Direction" eww-toggle-paragraph-direction :transient t)
    ("q" "Quit" quit-window :transient nil)]

   ["Casual"
    ("," "Settings" casual-eww-settings-tmenu :transient t)
    ("a" "About" casual-eww-about :transient t)]])

(transient-define-prefix casual-eww-settings-tmenu ()
  "Casual EWW settings menu."
  [["Settings"
    ("f" "Font Settings›" casual-eww-font-settings-tmenu :transient t)
    ("d" "Download Directory" casual-eww-set-download-directory :transient t)
    ("s" "Search Engine" casual-eww-set-search-prefix :transient t)
    ("r" "Readable URLs" casual-eww-configure-readable-urls :transient t)]]

  [["External Browser"
    ("b" "Set External Browser" casual-eww-set-external-browser :transient t)
    ("c" "Configure Content Types" casual-eww-configure-content-types :transient t)]]

  [["Return"
    ("<" "Back" casual-eww-tmenu :transient t)]])

(transient-define-prefix casual-eww-font-settings-tmenu ()
  "Casual EWW font settings menu."
  [["Font Display"
    ("f" "Use Fonts" eww-toggle-fonts :transient t)
    ("c" "Use Colors" eww-toggle-colors :transient t)
    ("i" "Show Images" eww-toggle-images :transient t)]]

  [["Return"
    ("<" "Back" casual-eww-settings-tmenu :transient t)]])

;;; Settings Functions

(defun casual-eww-set-download-directory ()
  "Set the EWW download directory."
  (interactive)
  (let ((dir (read-directory-name "EWW download directory: "
                                  eww-download-directory)))
    (setq eww-download-directory dir)
    (message "EWW download directory set to: %s" dir)))

(defun casual-eww-set-search-prefix ()
  "Set the EWW search engine prefix."
  (interactive)
  (let ((prefix (read-string "Search prefix URL: " eww-search-prefix)))
    (setq eww-search-prefix prefix)
    (message "EWW search prefix set to: %s" prefix)))

(defun casual-eww-set-external-browser ()
  "Set the external browser for EWW."
  (interactive)
  (let ((browser (read-string "External browser function: "
                              (symbol-name browse-url-secondary-browser-function))))
    (setq browse-url-secondary-browser-function (intern browser))
    (message "External browser set to: %s" browser)))

(defun casual-eww-configure-readable-urls ()
  "Configure URLs to display in readable mode by default."
  (interactive)
  (customize-variable 'eww-readable-urls))

(defun casual-eww-configure-content-types ()
  "Configure content types to open in external browser."
  (interactive)
  (customize-variable 'eww-use-external-browser-for-content-type))

;;; About

(defun casual-eww-about-eww ()
  "Casual EWW is a Transient menu for EWW (Emacs Web Wowser).

EWW is Emacs's built-in web browser, providing basic web browsing
capabilities within Emacs. Casual EWW provides an intuitive
Transient-based interface for common EWW operations.

Key Features:
- Page and history navigation
- Link navigation and management
- Content viewing options (readable mode, fonts, colors, images)
- Bookmark and buffer management
- Download and external browser integration
- Customizable settings

Learn more about using Casual EWW at our discussion group on GitHub.
Any questions or comments about it should be made there.
URL `https://github.com/kickingvegas/casual-suite/discussions'

If you find a bug or have an enhancement request, please file an issue.
Our best effort will be made to answer it.
URL `https://github.com/kickingvegas/casual-suite/issues'

If you enjoy using Casual EWW, consider making a modest financial
contribution to help support its development and maintenance.
URL `https://www.buymeacoffee.com/kickingvegas'

Casual EWW was conceived and crafted by Claude (Anthropic AI).

Thank you for using Casual EWW.

Always choose love."
  (ignore))

(defun casual-eww-about ()
  "About information for Casual EWW."
  (interactive)
  (describe-function #'casual-eww-about-eww))

(provide 'casual-eww)
;;; casual-eww.el ends here
