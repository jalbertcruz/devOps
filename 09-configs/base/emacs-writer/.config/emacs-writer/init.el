  ;; -*- lexical-binding: t; -*-
  ;;; This file is generated from the Emacs.org file in my dotfiles repository!
  ;;; ----- Basic Configuration -----
  ;; Core settings
  (setq ;; Yes, this is Emacs
        inhibit-startup-message t
        ;; Instruct auto-save-mode to save to the current file, not a backup file
        auto-save-default nil
        ;; No backup files, please
        make-backup-files nil
        ;; Make it easy to cycle through previous items in the mark ring
        set-mark-command-repeat-pop t
        ;; Don't warn on large files
        large-file-warning-threshold nil
        ;; Follow symlinks to VC-controlled files without warning
        vc-follow-symlinks t
        ;; Don't warn on advice
        ad-redefinition-action 'accept
        ;; Revert Dired and other buffers
        global-auto-revert-non-file-buffers t
        ;; Silence compiler warnings as they can be pretty disruptive
        native-comp-async-report-warnings-errors nil)

  ;; Core modes
  (repeat-mode 1)                ;; Enable repeating key maps
  (menu-bar-mode 0)              ;; Hide the menu bar
  (tool-bar-mode 0)              ;; Hide the tool bar
  (savehist-mode 1)              ;; Save minibuffer history
  (scroll-bar-mode 0)            ;; Hide the scroll bar
  (xterm-mouse-mode 1)           ;; Enable mouse events in terminal Emacs
  (display-time-mode 1)          ;; Display time in mode line / tab bar
  (column-number-mode 1)         ;; Show column number on mode line
  (tab-bar-history-mode 1)       ;; Remember previous tab window configurations
  (auto-save-visited-mode 1)     ;; Auto-save files at an interval
  (global-visual-line-mode 1)    ;; Visually wrap long lines in all buffers
  (global-auto-revert-mode 1)    ;; Refresh buffers with changed local files

  ;; Tabs to spaces
  (setq-default indent-tabs-mode nil
  	            tab-width 2)

  ;; Display line numbers in programming modes
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)

  ;; Delete trailing whitespace before saving buffers
  (add-hook 'before-save-hook 'delete-trailing-whitespace)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(setq user-home-directory (getenv "HOME"))
;;(setq user-home-directory "file:///home/z")
(add-to-list 'load-path (concat user-home-directory "/src/emacs/packages-src/org/org-mode/lisp/"))
(require 'org)

(require 'package)

(setq package-archives '(
                         ("elpa" . "http://localhost:9000/melpa/packages-elpa-gnu/")
                         ("melpa" . "http://localhost:9000/melpa/packages-melpa/")
                         ("local-melpa" . "http://localhost:9000/melpa/packages/")
                         ("stable-melpa" . "http://localhost:9000/melpa/packages-stable-melpa/")
                         )
)

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; Move customization settings out of init.el
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
(load custom-file t))

(setq visible-bell t)

(set-face-attribute 'default nil
                    :font "JetBrainsMono Nerd Font"
                    :weight 'light
                    :height 140)

(load-theme 'tango-dark)

(use-package elpa-clone
  :ensure t
  )

;; (use-package doom-modeline
;;   :ensure t
;;   ;; :autoload (list doom-modeline-mode doom-modeline-set-main-modeline )
;;   :init (doom-modeline-mode 1)
;;  ;; ;:vc (:url "file:///home/z/Documents/github/doom-modeline/")
;;   )

(use-package command-log-mode
  :ensure t
  )

;; (use-package smart-mode-line
;;   :ensure t
;;   )

(use-package keycast
  :ensure t
  )

;------------------------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;(setq persp-state-default-file (expand-file-name "perspectives.mk" user-emacs-directory))
(use-package elisp-autofmt
  :ensure t
  )
(use-package wgrep
  :ensure t
  )

(setq my-current-persp-name "default")
(setq persp-state-default-file (expand-file-name (concat "perspectives/" my-current-persp-name ".pps") user-emacs-directory))

(defun update-my-current-persp-name (new-name)
  "Update the current perspective name."
  (persp-state-save) ; Save the current perspective state
  (setq my-current-persp-name new-name)
  (persp-mode 0) ; Disable persp-mode to clear current state
  (mapc 'kill-buffer (buffer-list)) ; Close all buffers
  (persp-mode 1) ; Re-enable persp-mode
  (setq persp-state-default-file
        (expand-file-name (concat
                           "perspectives/"
                           my-current-persp-name
                           ".pps")
                          user-emacs-directory))
  (my/persp-state-load)
  (persp-switch-hook-function))

(defun reload-init-file ()
  "Reload the init file"
  (interactive)
  (load-file
    (expand-file-name (concat user-emacs-directory "/init.el"))
    )
)

  (use-package hl-todo
               :ensure t
               :hook (prog-mode . hl-todo-mode)
               :config
                       (setq hl-todo-keyword-faces
                             '(("TODO"   . "#FF0000")
                               ("FIXME"  . "#FF4500")
                               ("NOTE"   . "#1E90FF")
                               ("HACK"   . "#FFD700")
                               ("REVIEW" . "#00FF00")))
               ;; Keybindings for navigation
               :bind
                       (("C-c t n" . hl-todo-next)
                         ("C-c t p" . hl-todo-previous)
                         ("C-c t o" . hl-todo-occur)))

(use-package consult-todo :demand t)

(defun my/close-all-buffers-of-current-major-mode ()
    "Close all buffers whose major mode matches the current buffer."
    (interactive)
    (let ((current-mode major-mode))
      (dolist (buf (buffer-list))
              (with-current-buffer buf
                                   (when (eq major-mode current-mode)
                                         (kill-buffer buf))))))

(defun _my/open-all-files-of-current-major-mode ()
  "open all files"
  (interactive)
(let* ((mode-exts '((python-mode . (".py" ".pyw"))
                    (clojure-mode . (".clj" ".cljc" ".cljx" ".edn"))
                    (clojurescript-mode . (".cljs"))
                    (emacs-lisp-mode . (".el"))
                    (scala-mode . (".scala"))
                    (java-mode . (".java"))
                    (js-mode . (".js" ".jsx"))
                    (typescript-mode . (".ts" ".tsx"))
                    (ruby-mode . (".rb"))
                    (php-mode . (".php"))
                    (go-mode . (".go"))
                    (rust-mode . (".rs"))
                    (c++-mode . (".cpp" ".hpp" ".cc" ".cxx" ".hxx"))
                    (c-mode . (".c" ".h"))
                    (kotlin-mode . (".kt" ".kts"))
                    (elixir-mode . (".ex" ".exs"))
                    (sql-mode . (".sql"))
                    (csharp-mode . (".cs"))
                    (vue-mode . (".vue"))
                    (web-mode . (".html" ".htm"))))
       (exts (cdr (assoc major-mode mode-exts)))
       (root (projectile-project-root)))
  (dolist (file (projectile-current-project-files))
    (when (and exts (seq-some (lambda (ext) (string-suffix-p ext file)) exts))
      (find-file (expand-file-name file root)))))

)

(defun my/open-all-files-of-current-major-mode ()
  "Open all files in the current Projectile project matching the current major mode's extensions,
excluding files named Dependencies.* or plugins.*."
  (interactive)
  (let* ((mode-exts '((python-mode . (".py" ".pyw"))
                      (clojure-mode . (".clj" ".cljc" ".cljx" ".edn"))
                      (clojurescript-mode . (".cljs"))
                      (emacs-lisp-mode . (".el"))
                      (scala-mode . (".scala"))
                      (java-mode . (".java"))
                      (js-mode . (".js" ".jsx"))
                      (typescript-mode . (".ts" ".tsx"))
                      (ruby-mode . (".rb"))
                      (php-mode . (".php"))
                      (go-mode . (".go"))
                      (rust-mode . (".rs"))
                      (c++-mode . (".cpp" ".hpp" ".cc" ".cxx" ".hxx"))
                      (c-mode . (".c" ".h"))
                      (kotlin-mode . (".kt" ".kts"))
                      (elixir-mode . (".ex" ".exs"))
                      (sql-mode . (".sql"))
                      (csharp-mode . (".cs"))
                      (vue-mode . (".vue"))
                      (web-mode . (".html" ".htm"))))
         (exts (cdr (assoc major-mode mode-exts)))
         (root (projectile-project-root)))
    (when (and root exts)
      (let* ((files (projectile-current-project-files))
             (filtered
              (seq-filter
               (lambda (f)
                 (and (member (file-name-extension f t) exts)
                      (not (string-match-p
                            "\\(Dependencies\\|plugins\\|PluginsDependencies\\)\\.[^.]+$"
                            (file-name-nondirectory f)))))
               files)))
        (dolist (f filtered)
          (find-file (expand-file-name f root)))))))


(defun list-directories-in-dir (dirP)
  "Return a list of directories in DIR, excluding '.' and '..'."
  (setq dir (expand-file-name (concat user-emacs-directory dirP)))
  (setq result
        (seq-filter
         (lambda (f)
                 (let ((full (expand-file-name f dir)))
                   (and (file-directory-p full)
                        (not (member f '("." ".."))))))
         (directory-files dir))
        )
  (json-encode result)
  )

(use-package perspective
  ;:after consult
  :ensure t
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))  ; pick your own prefix key here
  :init
  (persp-mode))

(add-hook 'kill-emacs-hook #'persp-state-save)

(defun my/persp-state-load ()
  (if (file-exists-p persp-state-default-file)
      (progn
        ;(message "yes!!!")
        (persp-state-load persp-state-default-file)
        )
        ;(message "no!!!")
      )
  )


(my/persp-state-load)

(defun log-request (msg)
  (let (
         (my-hash (make-hash-table :test 'equal))
         (current-buffer (buffer-file-name (window-buffer (selected-window))))
         )
    (puthash "client" msg my-hash)

    (plz 'post "http://localhost:8099/api/v1/log"
         :headers '(("Content-Type" . "application/json"))
         :body
                  (json-encode my-hash)
         :as      #'json-read
         :then (lambda (alist)
                )
         ))

  )

(defun persp-switch-hook-function ()
  ;; (message "new perspective: %s" (persp-name (persp-curr)))
  ;; (log-request
  ;;  (concat "new perspective: " (persp-name (persp-curr)))
  ;;  )
  (let (
         (my-file-path
          (expand-file-name (concat "perspectives/" my-current-persp-name "/bookmarks/" (persp-name (persp-curr)) ".bmk")
                                      user-emacs-directory)
                       )
      )
    (if (file-exists-p my-file-path )
      (progn
       (setq bookmark-default-file my-file-path)
       (bookmark-load bookmark-default-file t t)
       )
      (bookmark-delete-all t)
      )
    )


  )
(persp-switch-hook-function)

(add-hook 'persp-switch-hook 'persp-switch-hook-function)

(defun persp-before-switch-hook-function ()
;; (message "previous perspective: %s" (persp-name (persp-curr)))
;; (log-request
;;  (concat "previous perspective: " (persp-name (persp-curr)))
;;  )
 (let ((dir
        (expand-file-name (concat "perspectives/" my-current-persp-name "/bookmarks/") user-emacs-directory)
        ))
  (unless (file-directory-p dir)
    (make-directory dir :parents)))

   (bookmark-write-file
    (expand-file-name (concat "perspectives/" my-current-persp-name "/bookmarks/" (persp-name (persp-curr)) ".bmk")
                      user-emacs-directory)
    )

  )

(add-hook 'persp-before-switch-hook 'persp-before-switch-hook-function)

(defun persp-killed-hook-function ()
  (message "perspective destroyed: %s" (persp-name (persp-curr)))
  ;(log-request (persp-name (persp-curr)))

  (let (
         (my-file-path
          (expand-file-name (concat "perspectives/" my-current-persp-name "/bookmarks/" (persp-name (persp-curr)) ".bmk")
                            user-emacs-directory)
          )
         )
    (if (file-exists-p my-file-path )
      (progn
       (delete-file
          my-file-path
        )
       )
      (bookmark-delete-all t)
      )
    )
  )

(add-hook 'persp-killed-hook 'persp-killed-hook-function)


(defun persp-merge-around-function (orig-fun &rest args)
  ; "Merge the buffer list of TO-MERGE-PERSP-NAME into the buffer list for BASE-PERSP-NAME."
  (let* ((base-persp-name (car args))
        (to-merge-persp-name (cadr args))

        (my-file-path
         (expand-file-name (concat "perspectives/" my-current-persp-name "/bookmarks/" to-merge-persp-name ".bmk")
                           user-emacs-directory)
         )
        )

    (message "base-persp-name: %s, to-merge-persp-name: %s" base-persp-name to-merge-persp-name)

    (if (file-exists-p my-file-path )
      (progn
       (setq bookmark-default-file my-file-path)
       (bookmark-load bookmark-default-file nil t)
       )
      )

    )
  (let ((res (apply orig-fun args)))
    ;(message "display-buffer returned %S" res)
    res))

(advice-add 'persp-merge :around #'persp-merge-around-function)

;-------------------------------------------<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

(use-package engrave-faces
  :ensure t
  )
(setq org-latex-src-block-backend 'engraved)

;; (require 'ox-latex)
;; (add-to-list 'org-latex-packages-alist '("" "listings"))
;; (add-to-list 'org-latex-packages-alist '("" "xcolor"))
;; (setq org-latex-src-block-backend 'listings)


(add-to-list 'load-path (concat user-home-directory "/src/emacs/extras/bookmark-plus/"))
(require 'bookmark+)
(add-to-list 'load-path (concat user-home-directory "/src/emacs/extras/dired-plus/"))
(require 'dired+)
(add-to-list 'load-path (concat user-home-directory "/src/emacs/extras/highlight/"))
(require 'highlight)


; https://protesilaos.com/codelog/2023-07-29-emacs-custom-modeline-tutorial/
(defun my-modeline--major-mode-name ()
  "Return capitalized `major-mode' as a string."
  (symbol-name major-mode))

(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                (:propertize
                 ("" mode-line-mule-info mode-line-client mode-line-modified
                  mode-line-remote)
                 display (min-width (5.0)))
                mode-line-frame-identification mode-line-buffer-identification "   "
                mode-line-position (vc-mode vc-mode) "  "
                mode-line-misc-info mode-line-end-spaces "   "   (:eval (my-modeline--major-mode-name))   ))

(use-package general)

;;;; EDITOR PACKAGES
;;; EVIL
;; evil
(use-package evil
  :init ;; tweak evil's configuration before loading it
  (setq evil-search-module 'evil-search
        evil-ex-complete-emacs-commands nil
        evil-vsplit-window-right t
        evil-split-window-below t
        evil-shift-round nil
        evil-want-C-u-scroll t
        evil-want-integration t
        evil-want-keybinding nil
        evil-normal-state-cursor 'box
        evil-search-module 'evil-search
        evil-undo-system 'undo-fu
        evil-respect-visual-line-mode t
        evil-shift-width tab-width)
  :general
  ;; j and k should operate line-by-line with text wrapping
  (;[remap evil-next-line] 'evil-next-visual-line
   ;[remap evil-previous-line] 'evil-previous-visual-line
   ;; inverse of evil jump backward
   "C-S-o" 'evil-jump-forward)
  :config
  ;; highlight the current line (not explicitly evil but whatever)
  (global-hl-line-mode 1)

  ;; make horizontal movement cross lines
  (setq-default evil-cross-lines t)

  ;; HACK prevent evil from moving window location when splitting by forcing a recenter
  ;; also do not switch to new buffer
  ;(advice-add 'evil-window-vsplit :after (lambda (&rest r) (progn (evil-window-prev 1) (recenter))))
  ;(advice-add 'evil-window-split :after (lambda (&rest r) (progn (evil-window-prev 1) (recenter))))

  ;; HACK
  (advice-add 'evil-window-vsplit :override (lambda (&rest r) (split-window (selected-window) nil 'right)))
  (advice-add 'evil-window-split :override (lambda (&rest r) (split-window (selected-window) nil 'below)))

  (evil-mode)

 (define-key evil-normal-state-map "ff" 'consult-fd)
 (define-key evil-normal-state-map "fw" 'my-consult-ripgrep-word-at-point)
 (define-key evil-normal-state-map "ft" 'consult-ripgrep)
 (define-key evil-normal-state-map "fb" 'bookmark-jump)
 (define-key evil-normal-state-map "fd" 'imenu)

             )

  (defun my-consult-ripgrep-word-at-point ()
    "Do a consult-ripgrep with the word at point."
    (interactive)
    (let ((search-term (thing-at-point 'word t)))
      (if search-term
        (consult-ripgrep nil search-term)
        (consult-ripgrep)))
    )

;(use-package goto-chg)

;; evil collection
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; evil surround
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

;; evil org
(use-package evil-org
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

;; evil-commentary
(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

;; change numbers with evil
(use-package evil-numbers)

;; show evil actions
(use-package evil-goggles
  :after evil
  :init
  (setq evil-goggles-duration 0.1)
  ;; disable slow actions
  (setq evil-goggles-enable-change nil)
  (setq evil-goggles-enable-delete nil)
  :config
  (evil-goggles-mode))


; TODO
;(use-package better-jumper
;  )

;; undo-fu/vundo stack
(use-package undo-fu
  :after evil
  :config
  ;; increase history limits
  ;; https://github.com/emacsmirror/undo-fu#undo-limits
  (setq undo-limit 6710886400 ;; 64mb.
        undo-strong-limit 100663296 ;; 96mb.
        undo-outer-limit 1006632960) ;; 960mb.
  )

(use-package undo-fu-session
  :after undo-fu
  :init
  (undo-fu-session-global-mode)
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'")))

(use-package vundo
  :config
  (setq vundo-compact-display t))

;; editor config
(use-package editorconfig
  :config
  (editorconfig-mode 1))

;; Recent files

(use-package recentf
  :config
  (recentf-mode t)
  :custom
  (recentf-max-saved-items 50)
  :bind
  (("C-c w r" . recentf-open)))
(require 'recentf)
(recentf-mode 1)
;; Save the recentf list when Emacs exits
(add-hook 'kill-emacs-hook 'recentf-save-list)


;;; VERTICO
;; vertico - completion engine
(use-package vertico
  :init
  (vertico-mode)
  ;; https://systemcrafters.cc/emacs-tips/streamline-completions-with-vertico/
  :general
  (:keymaps 'vertico-map
    "C-j" 'vertico-next
    "C-k" 'vertico-previous
    "DEL" 'vertico-directory-delete-char
    )
  :config
  (setq vertico-resize nil
        vertico-count 17
        ;; enable cycling for `vertico-next' and `vertico-previous'
        vertico-cycle t))

;; Optionally use the `orderless' completion style. See
;; `+orderless-dispatch' in the Consult wiki for an advanced Orderless style
;; dispatcher. Additionally enable `partial-completion' for file path
;; expansion. `partial-completion' is important for wildcard support.
;; Multiple files can be opened at once with `find-file' if you enter a
;; wildcard. You may also give the `initials' completion style a try.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

;; marginalia
(use-package marginalia
  :general
  ("M-A" 'marginalia-cycle)
  (:keymaps 'minibuffer-local-map
    "M-A" 'marginalia-cycle)
  :init
  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. NOTE that this forces loading the package.
  (marginalia-mode))

;; consult
(use-package consult
  :config
  ;; Use `consult-completion-in-region' if Vertico is enabled.
  ;; Otherwise use the default `completion--in-region' function.
  (setq completion-in-region-function
        (lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
                 args)))

(consult-customize consult--source-buffer :hidden t :default nil)
(add-to-list 'consult-buffer-sources persp-consult-source)

  )



;; consult functions
(defun +consult/find-file (DIR)
  "Open file in directory DIR."
  (interactive "DSelect dir: ")
  (let ((selection (completing-read "Find file: " (split-string (shell-command-to-string (concat "find " DIR)) "\n" t))))
    (find-file selection)))

(defun +consult/ripgrep (DIR)
  "Ripgrep directory DIR."
  (interactive "DSelect dir: ")
  ;(let ((consult-ripgrep-args "rg --null --multiline --max-columns=1000 --path-separator /\ --smart-case --no-heading --line-number .")))
  (consult-ripgrep DIR))

(defun +consult/org-roam-ripgrep ()
  "Ripgrep org-directory."
  (interactive)
  (consult-ripgrep org-directory))

;; allow me to use `evil-ex-search-next' and `evil-ex-search-previous' on result from `consult-line'
(defun +consult-line ()
  "Wrapper around `consult-line' that populates evil search history."
  (interactive)
  (consult-line)
  (let ((search-pattern (car consult--line-history)))
    ;; HACK manually set the search pattern and evil ex highlighting
    (setq evil-ex-search-pattern (evil-ex-make-search-pattern search-pattern))
    (evil-ex-search-activate-highlight evil-ex-search-pattern)))


;; embark
(use-package embark
  :general
  ("C-l" 'embark-act)
  ("<mouse-3>" 'embark-act) ;; right click
  (:keymaps 'evil-normal-state-map
    "C-l" 'embark-act
    "<mouse-3>" 'embark-act)
  :init
  ;; let "C-h" after a prefix command bring up a completion search using consult
  ;; https://www.reddit.com/r/emacs/comments/otjn19/comment/h6vyx9q/?utm_source=share&utm_medium=web2x&context=3
  (setq prefix-help-command #'embark-prefix-help-command
        which-key-use-C-h-commands nil))

(use-package embark-consult
  :after (embark consult))


;; posframe
(use-package posframe)
;;----


(use-package deadgrep)


;; spelling
;; (use-package flyspell
;;   ;; turn on flyspell for magit commit
;;   :hook (git-commit-setup . git-commit-turn-on-flyspell))

;; ;; spelling correction menu using completing-read (so consult)
;; (use-package flyspell-correct
;;   :after flyspell)

;; WORKSPACES/TABS
(use-package tab-bar
             ;:straight (:type built-in)
             :init
             ;; remember window configuration changes
                       (tab-bar-history-mode 1)
             :custom
             ;; hide tab back/forward buttons for tab-bar-history-mode
                       (tab-bar-format '(tab-bar-format-tabs tab-bar-separator tab-bar-format-add-tab))

             :config
                       (setq tab-bar-show nil
                             tab-bar-close-button-show nil
                             tab-bar-new-button-show nil))


(defun +tab-bar--tab-names-all ()
  "Return list of names of all tabs in current frame."
  (let ((tabs (tab-bar-tabs)))
    (mapcar (lambda (tab)
                    (alist-get 'name tab))
            tabs)))

(defun +tab-bar--tabline ()
  "Build string containing tab list, with the current tab highlighted."
  (let ((num-tabs (length (tab-bar-tabs)))
         (curr-index (tab-bar--current-tab-index))
         (tab-names (+tab-bar--tab-names-all)))
    (mapconcat
     #'identity
     (cl-loop for index from 0 to (1- num-tabs)
              collect
              (propertize (format " [%d] %s " (1+ index) (nth index tab-names))
                          'face (if (= curr-index index)
                                  'highlight
                                  'default)))
     " ")))

(defun +tab-bar--message (msg &optional face-type)
  "Build string containig tab tabline and custom message MSG with optional face type FACE-TYPE."
  (concat (+tab-bar--tabline)
          (propertize " | " 'face 'font-lock-comment-face)
          (propertize (format "%s" msg)
                      'face face-type))) ;; TODO check for face-type

(defun +tab-bar-message (msg &optional face-type)
  "Display tab tabline and custom message MSG with optional face type FACE-TYPE."
  (message "%s" (+tab-bar--message msg face-type)))

(defun +tab-bar/display ()
  "Display tab tabline at the bottom of the screen."
  (interactive)
  (message "%s" (+tab-bar--tabline)))


(defun +tab-bar/switch-by-index (index)
  "Switch to tab at index INDEX, if it exists."
  (interactive "P")
  (let ((curr-index (tab-bar--current-tab-index))
         (num-tabs (length (tab-bar-tabs))))
    (if (>= index num-tabs)
      (+tab-bar-message (format "Invalid tab index %d" (1+ index)) 'error)
      (if (eq index curr-index)
        (+tab-bar-message (format "Already in tab %d" (1+ index)) 'warning)
        (tab-bar-select-tab (1+ index)) ;; NOTE this index starts at 1 for this function
        (+tab-bar/display)))))


(defun +tab-bar/add-new ()
  "Create a new tab at the end of the list."
  (interactive)
  (let ((index (length (tab-bar-tabs))))
    (tab-bar-new-tab index)
    ;(open-scratch-buffer)
    (+tab-bar/display)))

(defun +tab-bar/close-tab ()
  "Close current tab and display tabline."
  (interactive)
  (let ((curr-index (tab-bar--current-tab-index))
         (num-tabs (length (tab-bar-tabs))))
    (if (eq num-tabs 1)
      (+tab-bar-message (format "Cannot kill last tab [%s]" (1+ curr-index)) 'error)
      (tab-bar-close-tab)
      (+tab-bar-message (format "Killed tab [%s]" (1+ curr-index)) 'success))))

(defun +tab-bar/close-all-tabs-except-current ()
  "Close all tabs other than the current tab."
  (interactive)
  (let ((curr-index (tab-bar--current-tab-index))
         (num-tabs (length (tab-bar-tabs))))
    (mapc (lambda
           (index)
           (unless (eq index (1+ curr-index))
                   (tab-bar-close-tab index)))
          ;; reverse list because going from first to last tab breaks indexing
          (reverse (number-sequence 1 num-tabs)))
    (+tab-bar-message (format "Killed all tabs other than [%s]" (1+ curr-index)) 'success)))

(defun +tab-bar/switch-to-next-tab ()
  "Switch to the next tab."
  (interactive)
  (tab-bar-switch-to-next-tab)
  (+tab-bar/display))

(defun +tab-bar/switch-to-prev-tab ()
  "Switch to the previous tab."
  (interactive)
  (tab-bar-switch-to-prev-tab)
  (+tab-bar/display))

(defun +tab-bar/switch-to-recent-tab ()
  "Switch to the most recently visited tab."
  (interactive)
  (tab-bar-switch-to-recent-tab)
  (+tab-bar/display))
;;----

;; ace window
(use-package ace-window)


;; themes
(use-package doom-themes
             :config
             ;; Global settings (defaults)
             (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
                   doom-themes-enable-italic t) ; if nil, italics is universally disabled
             (load-theme 'doom-one t)

             ;; Corrects (and improves) org-mode's native fontification.
             (doom-themes-org-config))


;; modeline
;; (use-package doom-modeline
;;              :hook (after-init . doom-modeline-mode)
;;              :hook (doom-modeline-mode . size-indication-mode) ; filesize in modeline
;;              :hook (doom-modeline-mode . column-number-mode)   ; cursor column in modeline
;;              ; https://github.com/hlissner/doom-emacs/blob/master/modules/ui/modeline/config.el
;;              :init
;;                    (unless after-init-time
;;                            ;; prevent flash of unstyled modeline at startup
;;                         (setq-default mode-line-format nil)
;;                         ;; (setq-default mode-line-format
;;                         ;;             '("%e" ; Error messages
;;                         ;;                 "%f" ; File name/buffer name
;;                         ;;                 "%b" ; Buffer name (alternative)
;;                         ;;                 "%I" ; Buffer size (KB/MB/GB)
;;                         ;;                 ,mode-line-buffer-identification
;;                         ;;                 ))

;;                                     )

;;              ;; We display project info in the modeline ourselves
;;              (setq projectile-dynamic-mode-line nil
;;                    ;; set these early so they don't trigger variable watchers
;;                    doom-modeline-bar-width 3
;;                    doom-modeline-buffer-file-name-style 'truncate-nil

;;                    ;; I don't like icons
;;                    doom-modeline-icon nil

;;                    ;; Only show file encoding if it's non-UTF-8 and different line endings
;;                    ;; than the current OSes preference
;;                    doom-modeline-buffer-encoding 'nondefault
;;                    ;; default line endings are LF on mac/linux, CRLF on windows
;;                    doom-modeline-default-eol-type (if (or (eq system-type 'gnu/linux) (eq system-type 'darwin)) 0 1))

;;              :config
;;              ;; display symlink file paths https://github.com/seagle0128/doom-modeline#faq
;;              (setq find-file-visit-truename t)
;;              ;; Don’t compact font caches during GC.
;;              (setq inhibit-compacting-font-caches t)

;;              ;; doom uses the default modeline that is defined here: https://github.com/seagle0128/doom-modeline/blob/master/doom-modeline.el#L90
;;              ;; as far as I can tell you can't change the ordering of segments without redefining the modeline entirely (segments can be toggled though)
;;              (doom-modeline-def-modeline 'my-line
;;                                          '(bar modals matches buffer-info buffer-position selection-info)
;;                                          '(buffer-encoding lsp major-mode process vcs check))

;;              ;; Add to `doom-modeline-mode-hook` or other hooks
;;              (defun setup-custom-doom-modeline ()
;;                (doom-modeline-set-modeline 'my-line 'default))
;;              (add-hook 'doom-modeline-mode-hook 'setup-custom-doom-modeline))


;; highlight todos
(use-package hl-todo
             :hook ((prog-mode . hl-todo-mode)
                     (markdown-mode . hl-todo-mode)
                     (org-mode . hl-todo-mode)
                     (LaTeX-mode . hl-todo-mode))
             :config
             ; https://github.com/hlissner/doom-emacs/blob/develop/modules/ui/hl-todo/config.el
                   (setq hl-todo-highlight-punctuation ":"
                         hl-todo-keyword-faces
                         `(;; For things that need to be done, just not today.
                           ("TODO" warning bold)
                           ;; For problems that will become bigger problems later if not
                           ;; fixed ASAP.
                           ("FIXME" error bold)
                           ;; For tidbits that are unconventional and not intended uses of the
                           ;; constituent parts, and may break in a future update.
                           ("HACK" font-lock-constant-face bold)
                           ;; For things that were done hastily and/or hasn't been thoroughly
                           ;; tested. It may not even be necessary!
                           ("REVIEW" font-lock-keyword-face bold)
                           ;; For especially important gotchas with a given implementation,
                           ;; directed at another user other than the author.
                           ("NOTE" success bold)
                           ;; For things that just gotta go and will soon be gone.
                           ("DEPRECATED" font-lock-doc-face bold)
                           ;; For a known bug that needs a workaround
                           ("BUG" error bold)
                           ;; For warning about a problematic or misguiding code
                           ("XXX" font-lock-constant-face bold)
                           ;; for temp comments or TODOs to be deleted
                           ("DELETEME" error bold)
                           ("KILLME" error bold)
                           ;; for works in progress
                           ("WIP" font-lock-keyword-face bold))))


;; rainbow delimiters
(use-package rainbow-delimiters
             :hook (LaTeX-mode . rainbow-delimiters-mode)
             :hook (prog-mode . rainbow-delimiters-mode))


;; highlight numbers
(use-package highlight-numbers
             :hook ((prog-mode . highlight-numbers-mode)))


;; code folding
;(use-package hs-mode
;  :straight (:type built-in)
;  :hook (prog-mode . hs-minor-mode))


;; anzu - show number of matches of search in modeline
(use-package evil-anzu
             ;:after-call evil-ex-start-search evil-ex-start-word-search evil-ex-search-activate-highlight
             :after evil
             :config
                    (global-anzu-mode +1))


;; better isearch
(use-package ctrlf
             :config
             (ctrlf-mode +1))


;; solaire mode - distinguish minibuffers from "real" buffers
(use-package solaire-mode
             :config
             (when (display-graphic-p)
                   (solaire-global-mode +1)))


;; which-key
(use-package which-key
             :init
             (setq which-key-sort-order #'which-key-key-order-alpha
                   which-key-sort-uppercase-first nil
                   which-key-add-column-padding 1
                   which-key-max-display-columns nil
                   which-key-min-display-lines 6
                   which-key-side-window-slot -10)
             (which-key-mode))


;; helpful
(use-package helpful
             :init
  (defvar read-symbol-positions-list nil)
             :config
             ;; reuse window for recursive helps
             ;; https://d12frosted.io/posts/2019-06-26-emacs-helpful.html
  (defun +helpful-switch-to-buffer (buffer-or-name)
    "Switch to helpful BUFFER-OR-NAME.

The logic is simple, if we are currently in the helpful buffer,
reuse it's window, otherwise create new one."
    (if (eq major-mode 'helpful-mode)
      (switch-to-buffer buffer-or-name)
      (pop-to-buffer buffer-or-name)))

             (setq helpful-switch-buffer-function #'+helpful-switch-to-buffer)

             ;; redefine help keys to use helpful functions instead of vanilla
             ;; https://github.com/Wilfred/helpful#usage
             :general ;; global
             ("C-h f" 'helpful-callable)
             ("C-h v" 'helpful-variable)
             ("C-h o" 'helpful-symbol)
             ("C-h k" 'helpful-key))

(defun helpful--skip-advice (docstring)
  "Remove mentions of advice from DOCSTRING."
  (let* ((lines (s-lines docstring))
          (relevant-lines
           (--take-while
            (not (or (s-starts-with-p ":around advice:" it)
                     (s-starts-with-p "This function has :around advice:" it)))
            lines)))
    (s-trim (s-join "\n" relevant-lines))))



;; HYDRA
(use-package hydra)


;; simple hydra for resizing windows
(defhydra hydra-window (:hint nil)
  "
^Movement^  ^Resize^
---------------------------------------
_h_ ←       _H_ X←
_j_ ↓       _J_ X↓
_k_ ↑       _K_ X↑
_l_ →       _L_ X→
"
  ("h" windmove-left)
  ("j" windmove-down)
  ("k" windmove-up)
  ("l" windmove-right)

  ("H" hydra-move-splitter-left)
  ("J" hydra-move-splitter-down)
  ("K" hydra-move-splitter-up)
  ("L" hydra-move-splitter-right))

(defun hydra-move-splitter-left (arg)
  "Move window splitter left."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
    (shrink-window-horizontally arg)
    (enlarge-window-horizontally arg)))

(defun hydra-move-splitter-right (arg)
  "Move window splitter right."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'right))
    (enlarge-window-horizontally arg)
    (shrink-window-horizontally arg)))

(defun hydra-move-splitter-up (arg)
  "Move window splitter up."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
    (enlarge-window arg)
    (shrink-window arg)))

(defun hydra-move-splitter-down (arg)
  "Move window splitter down."
  (interactive "p")
  (if (let ((windmove-wrap-around))
        (windmove-find-other-window 'up))
    (shrink-window arg)
    (enlarge-window arg)))

;; buffer/frame zoom hydra
(defhydra hydra-zoom (:hint nil)
  "
Buffer Zoom
-------------------------
_=_   text-scale-increase
_-_   text-scale-decrease
_r_   reset text scale

Frame Zoom
-------------------------
_M-=_ zoom-in
_M--_ zoom-out
_k_   zoom-in
_j_   zoom-out
_R_   reset frame zoom
"
  ("=" text-scale-increase)
  ("-" text-scale-decrease)
  ("r" (lambda () (interactive) (text-scale-adjust 0)))

  ("M-=" zoom-in)
  ("M--" zoom-out)
  ("k" zoom-in)
  ("j" zoom-out)
  ("R" (lambda () (interactive) (zoom-in/out 0))))

;; WIP hydra for smerge mode
(defhydra hydra-smerge (:hint nil :foreign-keys run)
  "
_j_: smerge-next
_k_: smerge-prev
_c_: smerge-keep-current
"
  ("j" smerge-next)
  ("k" smerge-prev)
  ("c" smerge-keep-current)
  ("q" nil :exit t)
  ("?" nil :exit t)
  ("<escape>" nil :exit t))

(defhydra hydra-git-gutter (:body-pre (git-gutter-mode 1)
                             :hint nil)
  "
Git gutter:
  _j_: next hunk        _s_tage hunk     _q_uit
  _k_: previous hunk    _r_evert hunk    _Q_uit and deactivate git-gutter
  ^ ^                   _p_opup hunk
  _h_: first hunk
  _l_: last hunk        set start _R_evision
"
  ("j" git-gutter:next-hunk)
  ("k" git-gutter:previous-hunk)
  ("h" (progn (goto-char (point-min))
              (git-gutter:next-hunk 1)))
  ("l" (progn (goto-char (point-min))
              (git-gutter:previous-hunk 1)))
  ("s" git-gutter:stage-hunk)
  ("r" git-gutter:revert-hunk)
  ("p" git-gutter:popup-hunk)
  ("R" git-gutter:set-start-revision)
  ("q" nil :color blue)
  ("Q" (progn (git-gutter-mode -1)
              ;; git-gutter-fringe doesn't seem to
              ;; clear the markup right away
              (sit-for 0.1)
              (git-gutter:clear))
       :color blue))
;;----

;; Load EWS functions
(load-file (concat (file-name-as-directory user-emacs-directory)
		   "ews.el"))

;; Scratch buffer settings
(setq initial-major-mode 'org-mode
      initial-scratch-message (concat "#+title: Emacs Writing Studio\n"
					"#+subtitle: Scratch Buffer\n\n"
					"The text in this buffer is not saved "
					"when exiting Emacs!\n\n"))

;; Spacious padding

(use-package spacious-padding
  :custom
  (line-spacing 3)
  (spacious-padding-mode 1))

;; Modus and EF Themes

(use-package modus-themes
  :custom
  (modus-themes-italic-constructs t)
  (modus-themes-bold-constructs t)
  (modus-themes-mixed-fonts t)
  (modus-themes-to-toggle '(modus-operandi-tinted
			    modus-vivendi-tinted))
  :bind
  (("C-c w t t" . modus-themes-toggle)
   ("C-c w t m" . modus-themes-select)
   ("C-c w t s" . consult-theme)))

(use-package ef-themes)

;; Mixed-pitch mode

(use-package mixed-pitch
  :hook
  (org-mode . mixed-pitch-mode))

;; Window management
;; Split windows sensibly

(setq split-width-threshold 120
      split-height-threshold nil)

;; Keep window sizes balanced

(use-package balanced-windows
  :config
  (balanced-windows-mode))

;; MINIBUFFER COMPLETION

;; ;; Improve keyboard shortcut discoverability

;; (use-package which-key
;;   :config
;;   (which-key-mode)
;;   :custom
;;   (which-key-max-description-length 40)
;;   (which-key-lighter nil)
;;   (which-key-sort-order 'which-key-description-order)
;;   :init
;;   (which-key-add-key-based-replacements
;;     "C-c w"   "Emacs Writing Studio"
;;     "C-c w b" "Bibliographic"
;;     "C-c w d" "Denote"
;;     "C-c w m" "Multimedia"
;;     "C-c w s" "Spelling and Grammar"
;;     "C-c w t" "Themes"
;;     "C-c w x" "Explore"))

;; Contextual menu with right mouse button

(when (display-graphic-p)
  (context-menu-mode))

;; Improved help buffers

(use-package helpful
  :bind
  (("C-h f" . helpful-function)
   ("C-h x" . helpful-command)
   ("C-h k" . helpful-key)
   ("C-h v" . helpful-variable)))

;;; Text mode settings

(use-package text-mode
  :ensure
  nil
  :hook
  (text-mode . visual-line-mode)
  :init
  (delete-selection-mode t)
  :custom
  (sentence-end-double-space nil)
  (scroll-error-top-bottom t)
  (save-interprogram-paste-before-kill t))

;; Check spelling with flyspell and hunspell

;; (use-package flyspell
;;   :custom
;;   ;; (ispell-program-name "hunspell")
;;   ;; (ispell-dictionary ews-hunspell-dictionaries)
;;   (flyspell-mark-duplications-flag nil) ;; Writegood mode does this
;;   (org-fold-core-style 'overlays) ;; Fix Org mode bug
;;   ;; :config
;;   ;; (ispell-set-spellchecker-params)
;;   ;; (ispell-hunspell-add-multi-dic ews-hunspell-dictionaries)
;;   :hook
;;   (text-mode . flyspell-mode)
;;   :bind
;;   (("C-c w s s" . ispell)
;;    ("C-;"       . flyspell-auto-correct-previous-word)))


;;; Ricing Org mode

(use-package org
  :custom
  (org-startup-indented t)
  (org-hide-emphasis-markers t)
  (org-startup-with-inline-images t)
  (org-image-actual-width '(450))
  (org-pretty-entities t)
  (org-use-sub-superscripts "{}")
  (org-id-link-to-org-use-id t)
  (org-fold-catch-invisible-edits 'show))

;; Show hidden emphasis markers

(use-package org-appear
  :hook
  (org-mode . org-appear-mode))

;; LaTeX previews

(use-package org-fragtog
  :after org
  :hook
  (org-mode . org-fragtog-mode)
  :custom
  (org-startup-with-latex-preview nil)
  (org-format-latex-options
   (plist-put org-format-latex-options :scale 2)
   (plist-put org-format-latex-options :foreground 'auto)
   (plist-put org-format-latex-options :background 'auto)))

;; Org modern: Most features are disabled for beginning users

(use-package org-modern
  :hook
  (org-mode . org-modern-mode)
  :custom
  (org-modern-table nil)
  (org-modern-keyword nil)
  (org-modern-timestamp nil)
  (org-modern-priority nil)
  (org-modern-checkbox nil)
  (org-modern-tag nil)
  (org-modern-block-name nil)
  (org-modern-keyword nil)
  (org-modern-footnote nil)
  (org-modern-internal-target nil)
  (org-modern-radio-target nil)
  (org-modern-statistics nil)
  (org-modern-progress nil))

;; INSPIRATION

;; Doc-View

(use-package doc-view
  :custom
  (doc-view-resolution 300)
  (large-file-warning-threshold (* 50 (expt 2 20))))

;; Read ePub files

(use-package nov
  :init
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; Managing Bibliographies

(use-package bibtex
  :custom
  (bibtex-user-optional-fields
   '(("keywords" "Keywords to describe the entry" "")
     ("file"     "Relative or absolute path to attachments" "" )))
  (bibtex-align-at-equal-sign t)
  :config
  (ews-bibtex-register)
  :bind
  (("C-c w b r" . ews-bibtex-register)))

;; Biblio package for adding BibTeX records

(use-package biblio
  :bind
  (("C-c w b b" . ews-bibtex-biblio-lookup)))

;; Citar to access bibliographies

(use-package citar
  :defer t
  :custom
  (citar-bibliography ews-bibtex-files)
  :bind
  (("C-c w b o" . citar-open)))

;; ;; Read RSS feeds with Elfeed

;; (use-package elfeed
;;   :custom
;;   (elfeed-db-directory
;;    (expand-file-name "elfeed" user-emacs-directory))
;;   (elfeed-show-entry-switch 'display-buffer)
;;   :bind
;;   ("C-c w e" . elfeed))

;; ;; Configure Elfeed with org mode

;; (use-package elfeed-org
;;   :config
;;   (elfeed-org)
;;   :custom
;;   (rmh-elfeed-org-files
;;    (list (concat (file-name-as-directory (getenv "HOME"))
;; 		 "elfeed.org"))))

;; Easy insertion of weblinks

(use-package org-web-tools
  :bind
  (("C-c w w" . org-web-tools-insert-link-for-url)))

;; ;; Emacs Multimedia System

;; (use-package emms
;;   :config
;;   (require 'emms-setup)
;;   (require 'emms-mpris)
;;   (emms-all)
;;   (emms-default-players)
;;   (emms-mpris-enable)
;;   :custom
;;   (emms-browser-covers #'emms-browser-cache-thumbnail-async)
;;   :bind
;;   (("C-c w m b" . emms-browser)
;;    ("C-c w m e" . emms)
;;    ("C-c w m p" . emms-play-playlist )
;;    ("<XF86AudioPrev>" . emms-previous)
;;    ("<XF86AudioNext>" . emms-next)
;;    ("<XF86AudioPlay>" . emms-pause)))

;; Open files with external applications

(use-package openwith
  :config
  (openwith-mode t)
  :custom
  (openwith-associations nil))

;; Fleeting notes

(use-package org
  :bind
  (("C-c c" . org-capture)
   ("C-c l" . org-store-link))
  :custom
  (org-capture-templates
   '(("f" "Fleeting note"
      item
      (file+headline org-default-notes-file "Notes")
      "- %?")
     ("p" "Permanent note" plain
      (file denote-last-path)
      #'denote-org-capture
      :no-save t
      :immediate-finish nil
      :kill-buffer t
      :jump-to-captured t)
     ("t" "New task" entry
      (file+headline org-default-notes-file "Tasks")
      "* TODO %i%?"))))

;; Denote

(use-package denote
  :defer t
  :custom
  (denote-sort-keywords t)
  (denote-link-description-function #'ews-denote-link-description-title-case)
  (denote-rename-buffer-mode 1)
  :hook
  (dired-mode . denote-dired-mode)
  :custom-face
  (denote-faces-link ((t (:slant italic))))
  :bind
  (("C-c w d b" . denote-find-backlink)
   ("C-c w d d" . denote-date)
   ("C-c w d l" . denote-find-link)
   ("C-c w d i" . denote-link-or-create)
   ("C-c w d k" . denote-rename-file-keywords)
   ("C-c w d n" . denote)
   ("C-c w d r" . denote-rename-file)
   ("C-c w d R" . denote-rename-file-using-front-matter)))

;; Denote auxiliary packages

(use-package denote-journal)

(use-package denote-org
  :bind
  (("C-c w d h" . denote-org-link-to-heading)))

(use-package denote-sequence)

;; ;; Consult convenience functions

;; (use-package consult
;;   :bind
;;   (("C-c w h" . consult-org-heading)
;;    ("C-c w g" . consult-grep))
;;   :config
;;   (add-to-list 'consult-preview-allowed-hooks 'visual-line-mode))

;; Consult-Notes for easy access to notes

(use-package consult-notes
  :custom
  (consult-notes-denote-display-keywords-indicator "_")
  :bind
  (("C-c w d f" . consult-notes)
   ("C-c w d g" . consult-notes-search-in-all-notes))
  :init
  (consult-notes-denote-mode))

;; Citar-Denote to manage literature notes

(use-package citar-denote
  :custom
  (citar-open-always-create-notes t)
  :init
  (citar-denote-mode)
  :bind
  (("C-c w b c" . citar-create-note)
   ("C-c w b n" . citar-denote-open-note)
   ("C-c w b x" . citar-denote-nocite)
   :map org-mode-map
   ("C-c w b k" . citar-denote-add-citekey)
   ("C-c w b K" . citar-denote-remove-citekey)
   ("C-c w b d" . citar-denote-dwim)
   ("C-c w b e" . citar-denote-open-reference-entry)))

;; Explore and manage your Denote collection

(use-package denote-explore
  :bind
  (;; Statistics
   ("C-c w x c" . denote-explore-count-notes)
   ("C-c w x C" . denote-explore-count-keywords)
   ("C-c w x b" . denote-explore-barchart-keywords)
   ("C-c w x e" . denote-explore-barchart-filetypes)
   ;; Random walks
   ("C-c w x r" . denote-explore-random-note)
   ("C-c w x l" . denote-explore-random-link)
   ("C-c w x k" . denote-explore-random-keyword)
   ("C-c w x x" . denote-explore-random-regex)
   ;; Denote Janitor
   ("C-c w x d" . denote-explore-identify-duplicate-notes)
   ("C-c w x z" . denote-explore-zero-keywords)
   ("C-c w x s" . denote-explore-single-keywords)
   ("C-c w x o" . denote-explore-sort-keywords)
   ("C-c w x w" . denote-explore-rename-keyword)
   ;; Visualise denote
   ("C-c w x n" . denote-explore-network)
   ("C-c w x v" . denote-explore-network-regenerate)
   ("C-c w x D" . denote-explore-barchart-degree)))

;; Set some Org mode shortcuts

(use-package org
  :bind
  (:map org-mode-map
        ("C-c w n" . ews-org-insert-notes-drawer)
        ("C-c w p" . ews-org-insert-screenshot)
        ("C-c w c" . ews-org-count-words)))

;; Distraction-free writing

;; (use-package olivetti
;;   :demand t
;;   :bind
;;   (("C-c w o" . ews-olivetti)))

;; ;; Vundo

;; (use-package vundo
;;   :bind
;;   (("C-M-/" . vundo)))

;; Export citations with Org Mode

(require 'oc-natbib)
(require 'oc-csl)

(setq org-cite-global-bibliography ews-bibtex-files
      org-cite-insert-processor 'citar
      org-cite-follow-processor 'citar
      org-cite-activate-processor 'citar)


;; Writegood-Mode for weasel words, passive writing and repeated word detection

(use-package writegood-mode
  :bind
  (("C-c w s r" . writegood-reading-ease))
  :hook
  (text-mode . writegood-mode))

;; Titlecasing

(use-package titlecase
  :bind
  (("C-c w s t" . titlecase-dwim)
   ("C-c w s c" . ews-org-headings-titlecase)))

;; Abbreviations

(add-hook 'text-mode-hook 'abbrev-mode)

;; Lorem Ipsum generator

(use-package lorem-ipsum
  :custom
  (lorem-ipsum-list-bullet "- ") ;; Org mode bullets
  :init
  (setq lorem-ipsum-sentence-separator
        (if sentence-end-double-space "  " " "))
  :bind
  (("C-c w s i" . lorem-ipsum-insert-paragraphs)))

;; ediff

(use-package ediff
  :ensure nil
  :custom
  (ediff-keep-variants nil)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-window-setup-function 'ediff-setup-windows-plain))

;; Enable Other text modes

;; Fountain mode for writing scripts
;; Markdown mode

(use-package fountain-mode)
(use-package markdown-mode)

;; PUBLICATION

;; Generic Org Export Settings

(use-package org
  :custom
  (org-export-with-drawers nil)
  (org-export-with-todo-keywords nil)
  (org-export-with-toc nil)
  (org-export-with-smart-quotes t)
  (org-export-date-timestamp-format "%e %B %Y"))

;; epub export

(use-package ox-epub
  :demand t
  :init
  (require 'ox-org))

;; LaTeX PDF Export settings

(use-package ox-latex
  :ensure nil
  :demand t
  :custom
  ;; Multiple LaTeX passes for bibliographies
  (org-latex-pdf-process
   '("pdflatex -interaction nonstopmode -output-directory %o %f"
     "bibtex %b"
     "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
     "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  ;; Clean temporary files after export
  (org-latex-logfiles-extensions
   (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out"
           "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk"
           "blg" "brf" "fls" "entoc" "ps" "spl" "bbl"
           "tex" "bcf"))))

;; EWS paperback configuration

(with-eval-after-load 'ox-latex
  (add-to-list
   'org-latex-classes
   '("ews"
     "\\documentclass[11pt, twoside, hidelinks]{memoir}
        \\setstocksize{9.25in}{7.5in}
        \\settrimmedsize{\\stockheight}{\\stockwidth}{*}
        \\setlrmarginsandblock{1.5in}{1in}{*}
        \\setulmarginsandblock{1in}{1.5in}{*}
        \\checkandfixthelayout
        \\layout
        \\setcounter{tocdepth}{0}
        \\renewcommand{\\baselinestretch}{1.25}
        \\setheadfoot{0.5in}{0.75in}
        \\setlength{\\footskip}{0.8in}
        \\chapterstyle{bianchi}
        \\setsecheadstyle{\\normalfont \\raggedright \\textbf}
        \\setsubsecheadstyle{\\normalfont \\raggedright \\emph}
        \\setsubsubsecheadstyle{\\normalfont\\centering}
        \\pagestyle{myheadings}
        \\usepackage[font={small, it}]{caption}
        \\usepackage{ccicons}
        \\usepackage{ebgaramond}
        \\usepackage[authoryear]{natbib}
        \\bibliographystyle{apalike}
        \\usepackage{svg}
\\hyphenation{mini-buffer}"
     ("\\chapter{%s}" . "\\chapter*{%s}")
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))))

;;; ADMINISTRATION

;; Bind org agenda command and custom agenda

(use-package org
  :custom
  (org-agenda-custom-commands
   '(("e" "Agenda, next actions and waiting"
      ((agenda "" ((org-agenda-overriding-header "Next three days:")
                   (org-agenda-span 3)
                   (org-agenda-start-on-weekday nil)))
       (todo "NEXT" ((org-agenda-overriding-header "Next Actions:")))
       (todo "WAIT" ((org-agenda-overriding-header "Waiting:")))))))
  :bind
  (("C-c a" . org-agenda)))

;; FILE MANAGEMENT

;; (use-package dired
;;   :ensure
;;   nil
;;   :commands
;;   (dired dired-jump)
;;   :custom
;;   (dired-listing-switches
;;    "-goah --group-directories-first --time-style=long-iso")
;;   (dired-dwim-target t)
;;   (delete-by-moving-to-trash t)
;;   :init
;;   (put 'dired-find-alternate-file 'disabled nil))

;; ;; Hide or display hidden files

;; (use-package dired
;;   :ensure nil
;;   :hook (dired-mode . dired-omit-mode)
;;   :bind (:map dired-mode-map
;;               ( "."     . dired-omit-mode))
;;   :custom (dired-omit-files "^\\.[a-zA-Z0-9]+"))

;; Backup files

(setq-default backup-directory-alist
              `(("." . ,(expand-file-name "backups/" user-emacs-directory)))
              version-control t
              delete-old-versions t
              create-lockfiles nil)


;; Image viewer
(use-package image-dired
  :bind
  (("C-c w I" . image-dired))
  (:map image-dired-thumbnail-mode-map
        ("C-<right>" . image-dired-display-next)
        ("C-<left>"  . image-dired-display-previous)))

;; Bind key for customising variables

(keymap-global-set "C-c w v" 'customize-variable)

;; Custom settings in a separate file and load the custom settings

(setq-default custom-file (expand-file-name
			     "custom.el"
			     user-emacs-directory))

(load custom-file :no-error-if-file-is-missing)

;; ADVANCED UNDOCUMENTED EXPORT SETTINGS FOR EWS

;; Use GraphViz for flow diagrams
;; requires GraphViz software

(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

; https://github.com/Automattic/harper/blob/master/packages/web/src/routes/docs/integrations/language-server/%2Bpage.md?plain=1#L270
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((org-mode :language-id "org") . ("harper-ls" "--stdio"))))

(setq-default eglot-workspace-configuration
              '(:harper-ls (:userDictPath ""
                            :workspaceDictPath ""
                            :fileDictPath ""
                            :linters (:SpellCheck t
                                      :SpelledNumbers :json-false
                                      :AnA t
                                      :SentenceCapitalization t
                                      :UnclosedQuotes t
                                      :WrongQuotes :json-false
                                      :LongSentences t
                                      :RepeatedWords t
                                      :Spaces t
                                      :Matcher t
                                      :CorrectNumberSuffix t)
                            :codeActions (:ForceStable :json-false)
                            :markdown (:IgnoreLinkTitle :json-false)
                            :diagnosticSeverity "hint"
                            :isolateEnglish :json-false
                            :dialect "American"
                            :maxFileLength 120000
                            :ignoredLintsPath ""
                            :excludePatterns [])))

;; (add-hook 'org-mode-hook 'eglot-ensure)

(defun config-service-request (path action)
  (let (
         (my-hash (make-hash-table :test 'equal))
         (current-buffer (buffer-file-name (window-buffer (selected-window))))
         )
    (puthash "current_file" current-buffer my-hash)
    (puthash "client" (symbol-name lsp-mark)  my-hash)
    (message current-buffer)

    (plz 'post (concat "http://localhost:8099/api/v1/" path)
         :headers '(("Content-Type" . "application/json"))
         :body
                  (json-encode my-hash)
         :as      #'json-read
         :then action
         ))

  )

(defun create-my-bookmarks ()
  "Create my custom bookmarks."
  (interactive)
  (config-service-request "create-bookmarks"

                          (lambda (alist)
                                  (let
                                    (
                                      (result (alist-get 'result alist))
                                      )


                                    (if (not (string= result "ok"))
                                      (message "Result => %s"
                                               result
                                               )
                                      )

                                    )


                                  )

                          )

  )
(defun load-my-bookmarks ()
  "Load my custom bookmarks."
  (interactive)
  (config-service-request "load-bookmarks"

                          (lambda (alist)
                                  (let
                                    (
                                      (result (alist-get 'result alist))
                                      )


                                    (if (not (string= result "ok"))
                                      (message "Result => %s"
                                               result
                                               )
                                      )

                                    )


                                  )
                          )

  )



(defun consult-grep-one-file ()
  "Call `consult-grep' for the current buffer (a single file)."
  (interactive)
  (let ((consult-grep-args
         (concat "grep "
                 "--line-buffered "
                 "--color=never "
                 "--line-number "
                 "--with-filename "
                 (shell-quote-argument buffer-file-name))))
    (consult-grep)))

(defun consult-ripgrep-single-file ()
    "Call `consult-ripgrep' for the current buffer (a single file)."
    (interactive)
    (let ((consult-project-function (lambda (x) nil))
          (consult-ripgrep-args
           (concat "rg "
                   "--null "
                   "--line-buffered "
                   "--color=never "
                   "--line-number "
                   "--smart-case "
                   "--no-heading "
                   "--max-columns=1000 "
                   "--max-columns-preview "
                   "--with-filename "
                   (shell-quote-argument buffer-file-name))))
      (consult-ripgrep)))

;; (elpa-clone "rsync://elpa.gnu.org/packages/" "/home/z/Documents/melpa/packages/")
(defun my-local-clone()
  "Make personal clone"
  (interactive)
  (elpa-clone "elpa.gnu.org::elpa/" (concat user-home-directory "/src/infra/process/wdir/caddy/public/melpa/packages-elpa-gnu/"))
  (elpa-clone "rsync://melpa.org/packages/" (concat user-home-directory "/src/infra/process/wdir/caddy/public/melpa/packages-melpa/"))
  (elpa-clone "rsync://stable.melpa.org/packages/" (concat user-home-directory "/src/infra/process/wdir/caddy/public/melpa/packages-stable-melpa/"))
  (message "Local clone done!!!")
  )

(use-package exec-path-from-shell
:ensure t
)

(exec-path-from-shell-initialize)

(use-package plz :ensure t )

(require 'json)
(require 'plz)

;; When you first call `find-file' (C-x C-f by default), you do not
;; need to clear the existing file path before adding the new one.
;; Just start typing the whole path and Emacs will "shadow" the
;; current one.  For example, you are at ~/Documents/notes/file.txt
;; and you want to go to ~/.emacs.d/init.el: type the latter directly
;; and Emacs will take you there.
(file-name-shadow-mode 1)

;; This works with `file-name-shadow-mode' enabled.  When you are in
;; a sub-directory and use, say, `find-file' to go to your home '~/'
;; or root '/' directory, Vertico will clear the old path to keep
;; only your current input.
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

;; Do not outright delete files.  Move them to the system trash
;; instead.  The `trashed' package can act on them in a Dired-like
;; fashion.  I use it and can recommend it to either restore (R) or
;; permanently delete (D) the files.
(setq delete-by-moving-to-trash t)

;; When there are two Dired buffers side-by-side make Emacs
;; automatically suggest the other one as the target of copy or rename
;; operations.  Remember that you can always use M-p and M-n in the
;; minibuffer to cycle through the history, regardless of what this
;; does.  (The "dwim" stands for "Do What I Mean".)
(setq dired-dwim-target t)

;; Automatically hide the detailed listing when visiting a Dired
;; buffer.  This can always be toggled on/off by calling the
;; `dired-hide-details-mode' interactively with M-x or its keybindings
;; (the left parenthesis by default).
(add-hook 'dired-mode-hook #'dired-hide-details-mode)
; https://www.gnu.org/software/emacs/manual/html_node/emacs/Misc-Dired-Features.html
;(setq dired-hide-details-hide-information-lines t)

;; Teach Dired to use a specific external program with either the
;; `dired-do-shell-command' or `dired-do-async-shell-command' command
;; (with the default keys, those are bound to `!' `&', respectively).
;; The first string is a pattern match against file names.  The
;; remaining strings are external programs that Dired will provide as
;; suggestions.  Of course, you can always type an arbitrary program
;; despite these defaults.
;;
;; Note that the * can be added to a program to instruct it to open
;; all the files as a set rather than all as separate instances.  You
;; write the name of the program, then space followed by the asterisk
;; (thanks to @mac68tm on YouTube for pointing this out).
(setq dired-guess-shell-alist-user
      '(("\\.\\(png\\|jpe?g\\|tiff\\)" "feh *" "xdg-open")
        ("\\.\\(mp[34]\\|m4a\\|ogg\\|flac\\|webm\\|mkv\\)" "mpv *" "xdg-open")
		(".*" "xdg-open")))


(use-package dash
             :ensure t
             )

(use-package ztree
             :ensure t
             )

(add-to-list 'load-path (concat user-home-directory "/src/emacs/packages-src/files-manager/dired-hacks/"))
(require 'dired-subtree)

(use-package diredc
:ensure t
  )

(global-set-key (kbd "S-<f11>") 'diredc)

(use-package dired-sidebar
:ensure t
:commands (dired-sidebar-toggle-sidebar))

;; https://protesilaos.com/codelog/2024-02-08-emacs-window-rules-display-buffer-alist/
;; Customize how Emacs displays certain buffers in windows
  
  (setq display-buffer-alist
      '(

        ;; The added space is for didactic purposes

        ;; Each entry in this list has this anatomy:

        ;; ( BUFFER-MATCHING-RULE
        ;;   LIST-OF-DISPLAY-BUFFER-FUNCTIONS
        ;;   OPTIONAL-PARAMETERS)

        ;; Match a buffer whose name is "*Occur*".  We have to escape
        ;; the asterisks to match them literally and not as a special
        ;; regular expression character.
        ("\\*Occur\\*"
         ;; If a buffer with the matching major-mode exists in some
         ;; window, then use that one.  Otherwise, display the buffer
         ;; below the current window.
         (display-buffer-reuse-mode-window display-buffer-below-selected)
         ;; Then we have the parameters...
         (dedicated . t)
         (window-height . fit-window-to-buffer))

        ))

;; If you want `switch-to-buffer' and related to respect those rules
;; (I personally do not want this, because if I am switching to a
;; specific buffer in the current window, I probably have a good
;; reason for it):
(setq switch-to-buffer-obey-display-actions t)

;; If you are in a window that is dedicated to its buffer and try to
;; `switch-to-buffer' there, tell Emacs to pop a new window instead of
;; using the current one:
(setq switch-to-buffer-in-dedicated-window 'pop)

;; Other relevant variables which control when Emacs splits the frame
;; vertically or horizontally, with some sample values (do `M-x
;; describe-variable' and search for those variables to learn more
;; about them):
(setq split-height-threshold 80)
(setq split-width-threshold 125)

;; Evaluate these to get to the relevant entries in the manual (NOTE
;; that this is advanced stuff):
;(info "(elisp) Displaying Buffers")
;(info "(elisp) Buffer Display Action Functions")
;(info "(elisp) Buffer Display Action Alists")
;(info "(elisp) Window Parameters")
