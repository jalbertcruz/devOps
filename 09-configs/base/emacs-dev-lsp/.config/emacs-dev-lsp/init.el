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

;;;; DEFUNS
;; revert buffer without confirmation
;; http://www.emacswiki.org/emacs-en/download/misc-cmds.el
(defun revert-buffer-no-confirm ()
    "Revert buffer without confirmation."
    (interactive)
    (revert-buffer :ignore-auto :noconfirm))

;; kill all other buffers
;; https://www.emacswiki.org/emacs/KillingBuffers#h5o-2
(defun kill-other-buffers ()
     "Kill all other buffers."
     (interactive)
     (mapc #'kill-buffer (delq (current-buffer) (buffer-list))))

;; open init.el
(defun open-init-file ()
  "Open the init file."
  (interactive)
  (find-file user-init-file))


;; inspired by https://owoga.com/how-to-zap-whitespace-in-emacs/
(defun delete-whitespace-left-of-cursor ()
  "Delete all whitespace to the left of cursor's current position."
  (interactive)
  (let ((skip-chars "\t\n\r ")
        (old-point (point)))
    (skip-chars-backward skip-chars)
    (let ((start (point)))
      (delete-region start old-point))))

;; I like the behaviour of evil-delete-backward-word over backward-kill-word, this is a small wrapper to make it more usable for me
(defun my-backward-kill-word ()
  "Wrapper around evil-delete-backward-word."
  (interactive)
  (if (or (bolp) (eq (current-column) (current-indentation)))
      (delete-whitespace-left-of-cursor)
    (evil-delete-backward-word)))

;; basically the same as my-backward-kill-word except it creates a space when merging lines
;; TODO repeated code, this should likely be merged into my-backward-kill-word
(defun my-backward-kill-line ()
  "Same as my-backward-kill-word, but insert a space after merging lines."
  (interactive)
  (if (or (bolp) (eq (current-column) (current-indentation)))
      (progn
        (my-backward-kill-word)
        (insert " "))
    (evil-delete-backward-word)))


;; backward-kill-word without copying to kill-ring
;; https://www.emacswiki.org/emacs/BackwardDeleteWord
(defun delete-word (arg)
  "Delete characters forward until encountering the end of a word ARG times."
  (interactive "p")
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-region (point) (progn (forward-word arg) (point)))))

;; this is mainly for allowing me to use C-w to delete words in vertico buffers (see general.el for hotkeys)
(defun backward-delete-word (arg)
  "Delete characters backward until encountering the end of a word ARG times."
  (interactive "p")
  (delete-word (- arg)))


;; https://github.com/hlissner/doom-emacs/blob/master/core/autoload/text.el#L293
(defun toggle-indent-style ()
  "Toggle use of tabs or spaces."
  (interactive)
  (setq indent-tabs-mode (not indent-tabs-mode))
  (message "Indent style changed to %s" (if indent-tabs-mode "tabs" "spaces")))

;; https://www.emacswiki.org/emacs/ToggleWindowSplit
(defun toggle-window-split ()
  "Toggle horizontal/vertical split."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;; useful to have on an easily accessible key
(defun open-scratch-buffer ()
  "Open *scractch* buffer."
  (interactive)
  (switch-to-buffer "*scratch*"))

;; useful for emacs daemon
(defun +reload-config ()
  "Reload `init.el' without closing Emacs."
  (interactive)
  (load-file user-init-file))

(defun string-equality (s1 s2)
  "Quickly test equality of two strings s1 s2."
  (interactive "sEnter first string: \nsEnter second string: ")
  (if (string= s1 s2)
      (message "Equal!")
    (message "Not equal!")))

(defun +which-function ()
  "Interactive wrapper of `which-function'"
  (interactive)
  (message (which-function)))

(defun +toggle-show-trailing-whitespace ()
  "Toggle show-trailing-whitespace."
  (interactive)
  (if show-trailing-whitespace
      (setq show-trailing-whitespace nil)
    (setq show-trailing-whitespace t)))
;;----


;; ADVICE/HOOKS
(defun +tab--jump-out (oldfun &rest args)
  "Forward-char if next-char is a delimiter, otherwise call OLDFUN with ARGS."
  (let ((delimiters '("(" ")" "[" "]" "{" "}" "\\" "<" ">" ";" "|" "`" "'" "\""))
        (next-char (string (char-after))))
    (if (member next-char delimiters)
        (forward-char)
      (apply oldfun args))))

(advice-add 'indent-for-tab-command :around #'+tab--jump-out)
(advice-add 'org-cycle :around #'+tab--jump-out)

;; automatically clone the emacs source repo if needed (in source directory)
;; https://github.com/raxod502/radian/blob/develop/emacs/radian.el#L3954
(defun +clone-emacs-source (&rest _)
  "Prompt user to clone Emacs source repository if needed."
  (when (and (not (file-directory-p source-directory))
             (not (get-buffer "*clone-emacs-src*"))
             (yes-or-no-p "Clone Emacs source repository? "))
    (make-directory (file-name-directory source-directory) 'parents)
    (let ((compilation-buffer-name-function
           (lambda (&rest _)
             "*clone-emacs-src*")))
      (save-current-buffer
        (compile
         (format
          "git clone https://github.com/emacs-mirror/emacs.git %s"
          (shell-quote-argument source-directory)))))))

(advice-add 'find-function-C-source :before #'+clone-emacs-source)

(defun c-mode-hook ()
  ;; disable tab indentation
  (setq indent-tabs-mode nil
        evil-shift-width 4))

(add-hook 'c-mode-hook #'c-mode-hook)
(add-hook 'c++-mode-hook #'c-mode-hook)

(use-package yasnippet
:ensure t
:config
  (yas-global-mode 1)
)

  (defun my/send-snippet-region-info ()
    "Send buffer content and snippet info as a single JSON request."
    (save-buffer)
    (when (and (boundp 'yas-snippet-beg)
               (boundp 'yas-snippet-end)
               yas-snippet-beg yas-snippet-end)
          (let* ((snippet-text (buffer-substring-no-properties yas-snippet-beg yas-snippet-end))
                  (mode (symbol-name major-mode))
                  (project-root (if (featurep 'projectile)
                                  (projectile-project-root)
                                  default-directory))
                  (point (point))
                  (line (line-number-at-pos))
                  (column (current-column))
                  (buffer-content (buffer-substring-no-properties (point-min) (point-max)))
                  (base64-content (base64-encode-string buffer-content))
                  (full-path (buffer-file-name))
                  (payload (let ((h (make-hash-table :test 'equal)))
                             (puthash "snippet" snippet-text h)
                             (puthash "major_mode" mode h)
                             (puthash "project_root" project-root h)
                             (puthash "point" point h)
                             (puthash "line" line h)
                             (puthash "column" column h)
                             (puthash "full_path" full-path h)
                             h)))
            (plz 'post "http://localhost:8099/api/v1/snippet-info"
                 :headers '(("Content-Type" . "application/json"))
                 :body (json-encode payload)
                 :as #'json-read))))
(add-hook 'yas-after-exit-snippet-hook #'my/send-snippet-region-info)

  (defun my/check-xref-not-found (message-function &rest args)
;    (progn
;     (print "a")
;     (print "b")
;      )
    (if
      (and
        (and (listp args) (> (length args) 1))
        (fboundp 'log-request)
        )

      (let ((msg (apply #'format (car args) (cdr args))))
        (when (and (stringp msg)
                   (string-equal msg "No definitions found for: LSP identifier at point"))
              (log-request msg)))
      (let ((res (apply message-function args)))
        ;(message "display-buffer returned %S" res)
        res)))

(advice-add 'message :around #'my/check-xref-not-found)

(defun capitalize-first (s)
  "Capitalize only the first character of S, leave the rest unchanged."
  (if (and s (> (length s) 0))
    (concat (upcase (substring s 0 1)) (substring s 1))
    s))


;(defun my-jump-to-location ()
;    "Prompt with a list of locations and jump to the selected one."
;    (interactive)
;    (let* ((locations '(("Init.el line 10" . ("/home/z/.config/emacs-dev-eglot/init.el" . 100))
;                        ("Config.el line 42" . ("/home/z/.config/emacs-dev-eglot/custom.el" . 2))))
;            (choice (completing-read "Jump to: " (mapcar #'car locations)))
;            (file-pos (cdr (assoc choice locations))))
;      (when file-pos
;            (find-file (car file-pos))
;            (goto-char (point-min))
;            (forward-line (1- (cdr file-pos))))))

  (setq locate-position "
  {
    \"path\": \"/home/z/.config/emacs-dev-eglot/init.el\",
    \"line\": 201,
    \"column\": 20
  }
  ")

  (defun my/open-location ()
    "Open file and jump to line and column from `locate-position` JSON."
    ;(interactive)
    (let* ((location (json-read-from-string locate-position))
            (path (alist-get 'path location))
            (line (alist-get 'line location))
            (column (alist-get 'column location)))
      (find-file path)
      (goto-char (point-min))
      (forward-line (1- line))
      (move-to-column (1- column))))

  (setq files-and-positions "
  [
  {
    \"entry\": \"Init.el\",
    \"path\": \"/home/z/.config/emacs-dev-eglot/init.el\",
    \"line\": 201,
    \"column\": 20
  },
  {
    \"entry\": \"Config.el\",
    \"path\": \"/home/z/.config/emacs-dev-eglot/custom.el\",
    \"line\": 2,
    \"column\": 2
  }
  ]
  ")


  (defun my/jump-to-location ()
    "Prompt with a list of locations from `files-and-positions` JSON and jump to the selected one."
    (interactive)
    (let* (
;            (json-array-type 'list)
;            (json-object-type 'alist)
            (locations (json-read-from-string files-and-positions))
            (choices (mapcar (lambda (loc)
                                     (let ((entry (alist-get 'entry loc))
                                            (line (alist-get 'line loc))
                                            (col (alist-get 'column loc)))
                                       (cons (format "%s (line %d, col %d)" entry line col) loc)))
                             locations))
            (choice (completing-read "Jump to: " (mapcar #'car choices)))
            (selected (cdr (assoc choice choices))))
      (when selected
            (find-file (alist-get 'path selected))
            (goto-char (point-min))
            (forward-line (1- (alist-get 'line selected)))
            (move-to-column (alist-get 'column selected)))))

  (defun my-jump-to-location ()
    "Prompt with a list of locations and jump to the selected one."
    (interactive)
    (let* ((locations (list
                       (cons "Init.el line 10" (cons "/home/z/.config/emacs-dev-eglot/init.el" 100))
                       (cons "Config.el line 42" (cons "/home/z/.config/emacs-dev-eglot/custom.el" 2))))
            (choice (completing-read "Jump to: " (mapcar #'car locations)))
            (file-pos (cdr (assoc choice locations))))
      (when file-pos
            (find-file (car file-pos))
            (goto-char (point-min))
            (forward-line (1- (cdr file-pos))))))

(use-package markdown-mode
:ensure t
  )

;;----

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

;;; GENERAL.EL
;; https://github.com/hlissner/doom-emacs/blob/master/modules/config/default/config.el#L6
(defvar default-minibuffer-maps
  (append '(minibuffer-local-map
            minibuffer-local-ns-map
            minibuffer-local-completion-map
            minibuffer-local-must-match-map
            minibuffer-local-isearch-map
            read-expression-map))
  "A list of all the keymaps used for the minibuffer.")

(defun my-lsp-find-def()
   "lsp find def"
    (interactive)
    (if (bound-and-true-p lsp-bridge-mode)
        (lsp-bridge-find-def)
        (lsp-find-definition)
    )
  )
    ;"sd" '(lsp-find-definition :which-key "lsp find definition")
    ;"sd" '(lsp-bridge-find-def :which-key "lsp find definition")

;; general keybindings
(use-package general
  :config
  (general-evil-setup t)
  (defconst my-leader "SPC")
  (general-create-definer my-leader-def
    :prefix my-leader)
  (general-override-mode) ;; https://github.com/noctuid/general.el/issues/99#issuecomment-360914335
  ;; doomesque hotkeys using spacebar as prefix
  (my-leader-def
    :states '(motion normal visual)
    :keymaps 'override ;; https://github.com/noctuid/general.el/issues/99#issuecomment-360914335

    ;; map universal argument to SPC-u
    "u" '(universal-argument :which-key "Universal argument")
    ";" '(eval-region :which-key "eval-region")
    "SPC" '(projectile-find-file :which-key "Projectile find file")
    "C-SPC" '(projectile-find-file-other-frame :which-key "Projectile find file (new frame)")
    "S-SPC" '(projectile-find-file-other-frame :which-key "Projectile find file (new frame)")
    "." '(find-file :which-key "Find file")
    ">" '(find-file-other-frame :which-key "Find file (new frame)")
    "," '(consult-buffer :which-key "consult-buffer")
    ;":" '(execute-extended-command :which-key "M-x")
    "x" '(open-scratch-buffer :which-key "Open scratch buffer")
    "d" '(dired-jump :which-key "dired-jump")
    "/" '(+consult/ripgrep :which-key "+consult/ripgrep")
    "?" '(consult-ripgrep :which-key "consult-ripgrep")
    ;"[" '(+tab-bar/switch-to-prev-tab :which-key "+tab-bar/switch-to-prev-tab")
    ;"]" '(+tab-bar/switch-to-next-tab :which-key "+tab-bar/switch-to-next-tab")
    "v" '(vterm-toggle :which-key "vterm-toggle")
    "a" '(ace-window :which-key "ace-window")
    "l" '(ace-window :which-key "ace-window")

    ;; editor
    "e" '(:ignore t :which-key "Editor")
    "eu" '(vundo :which-key "vundo")
    "ev" '(vundo :which-key "vundo")
    "er" '(query-replace :which-key "query-replace")
    ;"ec" '(consult-theme :which-key "consult-theme")
    "ep" '(point-to-register :which-key "point-to-register")
    "es" '(consult-register-store :which-key "consult-register-store")
    "ej" '(jump-to-register :which-key "jump-to-register")
    "ef" '(:ignore t :which-key "Fold")
    "efh" '(hs-hide-block :which-key "hs-hide-block")
    "efs" '(hs-show-block :which-key "hs-show-block")
    "efa" '(hs-show-all :which-key "hs-show-all")

    ;; consult
    "c" '(:ignore t :which-key "consult")
    "cf" '(consult-flymake :which-key "consult-flymake")
    "ct" '(consult-theme :which-key "consult-theme")
    "cm" '(consult-man :which-key "consult-man")
    ;"cg" '(:ignore t :which-key "Grep")
    ;"cgr" '(consult-ripgrep :which-key "consult-ripgrep")
    ;"cgg" '(consult-git-grep :which-key "consult-git-grep")
    ;"cb" '(consult-buffer :which-key "consult-buffer")
    "ci" '(consult-imenu :which-key "consult-imenu")

    ;; buffer
    ;"TAB" '(switch-to-prev-buffer :which-key "Prev buffer")
    "b" '(:ignore t :which-key "Buffer")
    "bb" '(consult-buffer :which-key "consult-buffer")
    "b[" '(previous-buffer :which-key "Previous buffer")
    "b]" '(next-buffer :which-key "Next buffer")
    "bd" '(kill-current-buffer :which-key "Kill buffer")
    "bk" '(kill-current-buffer :which-key "Kill buffer")
    "bl" '(evil-switch-to-windows-last-buffer :which-key "Switch to last buffer")
    "br" '(revert-buffer-no-confirm :which-key "Revert buffer")
    "bK" '(kill-other-buffers :which-key "Kill other buffers")

    ;; open
    "o" '(:ignore t :which-key "Open")
    "oc" '(open-init-file :which-key "Open init.el")

    ;; project
    "p" '(:ignore t :which-key "Project")
    "pp" '(projectile-switch-project :which-key "Switch Project")
    "po" '(projectile-find-other-file :which-key "projectile-find-other-file")

    ;; help
    "h" '(:ignore t :which-key "Help")
    "hf" '(helpful-callable :which-key "describe-function")
    "hk" '(helpful-key :which-key "describe-key")
    "hv" '(helpful-variable :which-key "describe-variable")
    "ho" '(helpful-symbol :which-key "describe-symbol")
    "hm" '(describe-mode :which-key "describe-mode")
    "hF" '(describe-face :which-key "describe-face")
    "hw" '(where-is :which-key "where-is")
    "h." '(display-local-help :which-key "display-local-help")

    ;; zoom
    ;; the hydra is nice but the rest is kind of janky, need to play around with this more
    "=" '(text-scale-increase :which-key "text-scale-increase")
    "-" '(text-scale-decrease :which-key "text-scale-decrease")
    "z" '(:ignore t :which-key "zoom")
    "z=" '(zoom-in :which-key "zoom-in")
    "z-" '(zoom-out :which-key "zoom-out")
    "zz" '(hydra-zoom/body :which-key "hydra-zoom")

    ;; window
    "w" '(:ignore t :which-key "Window")
    "ww" '(ace-window :which-key "ace-window")
    "wt" '(toggle-window-split :which-key "toggle-window-split")
    "wa" '(ace-window :which-key "ace-window")
    "wr" '(hydra-window/body :which-key "hydra-window")
    "wv" '(evil-window-vsplit :which-key "vertical split")

    ;; toggles
    "t" '(:ignore t :which-key "Toggles")
    ;"ta" '(corfu-mode :which-key "corfu-mode") ;; 'a' for autocomplete
    "ts" '(flyspell-mode :which-key "flyspell-mode")
    "tf" '(flyspell-mode :which-key "flyspell-mode")
    "tc" '(flymake-mode :which-key "flymake-mode")
    "tg" '(evil-goggles-mode :which-key "evil-goggles")
    "tI" '(toggle-indent-style :which-key "Indent style")
    "tv" '(visual-line-mode :which-key "visual-line-mode")

    ;; ;; notes/org
    ;; "n" '(:ignore t :which-key "Notes")
    ;; "nf" '(org-roam-node-find :which-key "find-node")
    ;; "ni" '(org-roam-node-insert :which-key "insert-node")
    ;; "nt" '(org-roam-dailies-goto-today :which-key "org-roam-dailies-goto-today")
    ;; "n/" '(+consult/org-roam-ripgrep :which-key "+consult/org-roam-ripgrep")
    ;; "na" '(org-agenda :which-key "org-agenda")

    ;; narrow
    "N" '(:ignore t :which-key "Narrow")
    "Nr" '(narrow-to-region :which-key "narrow-to-region")
    "Nw" '(widen :which-key "widen")

    ;; tabs
    "TAB" '(:ignore t :which-key "Tabs")
    "TAB TAB" '(tab-bar-switch-to-tab :which-key "tab-bar-switch-to-tab")
    "TAB [" '(+tab-bar/switch-to-prev-tab :which-key "+tab-bar/switch-to-prev-tab")
    "TAB ]" '(t+ab-bar/switch-to-next-tab :which-key "+tab-bar/switch-to-next-tab")
    "TAB n" '(+tab-bar/add-new :which-key "+tab-bar/add-new")
    "TAB k" '(+tab-bar/close-tab :which-key "+tab-bar/close-tab")
    "TAB d" '(+tab-bar/close-tab :which-key "+tab-bar/close-tab")
    "TAB K" '(+tab-bar/close-all-tabs-except-current :which-key "+tab-bar/close-all-tabs-except-current")
    "TAB r" '(tab-rename :which-key "tab-rename")

    ;; quick tab switching
    "1" '((lambda () (interactive) (+tab-bar/switch-by-index 0)) :which-key nil)
    "2" '((lambda () (interactive) (+tab-bar/switch-by-index 1)) :which-key nil)
    "3" '((lambda () (interactive) (+tab-bar/switch-by-index 2)) :which-key nil)
    "4" '((lambda () (interactive) (+tab-bar/switch-by-index 3)) :which-key nil)
    "5" '((lambda () (interactive) (+tab-bar/switch-by-index 4)) :which-key nil)
    "6" '((lambda () (interactive) (+tab-bar/switch-by-index 5)) :which-key nil)
    "7" '((lambda () (interactive) (+tab-bar/switch-by-index 6)) :which-key nil)
    "8" '((lambda () (interactive) (+tab-bar/switch-by-index 7)) :which-key nil)
    "9" '((lambda () (interactive) (+tab-bar/switch-by-index 8)) :which-key nil)

    ;; git
    "g" '(:ignore t :which-key "Git") ; prefix
    "gg" '(magit-status :which-key "Git status")


    "s" '(:ignore t :which-key "Clojure")
    "sj" '(cider-jack-in-clj :which-key "cider-jack-in-clj")
    "sm" '(symex-mode-interface :which-key "symex-mode-interface")
    ;"sd" '(lsp-find-definition :which-key "lsp find definition")
    ;"sd" '(lsp-bridge-find-def :which-key "lsp find definition")
    "sd" '(my-lsp-find-def :which-key "lsp find definition")

    )

  ;; minibuffer keybindings
  (general-define-key
    :keymaps default-minibuffer-maps
    [escape] 'abort-recursive-edit ;; escape should always quit

    "C-a" 'move-beginning-of-line
    "C-e" 'move-end-of-line

    "C-w" 'backward-delete-word
    "C-v" 'yank)

  ;; evil bindings
  ;; TODO this is a bit of a mess, I need to go through the state hierarchy to define hotkeys in highest priority
  ;; normal/visual mode hotkeys
  (general-define-key
    :states '(normal visual)
    ;; evil numbers
    "g=" 'evil-numbers/inc-at-pt
    "g-" 'evil-numbers/dec-at-pt

    ;; go to references
    "gr" 'xref-find-references
    "gD" 'xref-find-references

    ;; flyspell correct
    ;; "z=" 'flyspell-correct-wrapper
    ;; "C-;" 'flyspell-correct-wrapper
    ;"z=" 'jinx-correct
    ;"C-;" 'jinx-correct

    ;; movement
    "C-n" 'evil-next-visual-line ;; TODO should be in motion? doesn't seem to go down to these states? DELETEME
    "C-p" 'evil-previous-visual-line
    "M-n" 'flymake-goto-next-error
    "M-p" 'flymake-goto-prev-error
    "s" 'avy-goto-char-2
    "S" 'avy-goto-char-timer)

  ;; insert mode hotkeys
  (general-define-key
    :states 'insert
    "C-SPC" 'completion-at-point ;; trigger capf
    "C-v" 'yank ;; C-v should paste clipboard contents

    "C-<backspace>" 'my-backward-kill-word
    "M-<backspace>" 'my-backward-kill-line

    ;; some emacs editing hotkeys inside insert mode
    "C-a" 'evil-beginning-of-visual-line
    "C-e" 'evil-end-of-visual-line
    "C-n" 'evil-next-visual-line
    "C-p" 'evil-previous-visual-line
    ;"C-k" 'kill-whole-line ; not sure why I wanted this?
    "C-k" 'eldoc-doc-buffer
    )

  ;; motion mode hotkeys, inherited by normal/visual
  (general-define-key
    :states 'motion
    "?" '+consult-line

    ;; window management
    ;"C-w C-u" 'winner-undo
    ;"C-w u" 'winner-undo
    "C-w C-u" 'tab-bar-history-back
    "C-w u" 'tab-bar-history-back

    "C-w a" 'ace-window
    "C-w C-w" 'ace-window
    "C-w w" 'ace-window

    "C-w C-l" 'evil-window-right
    "C-w C-h" 'evil-window-left)

  ;; unbind C-z from evil
  (general-unbind '(motion insert) "C-z")

  ;; key bindings for evil search ('/')
  ;; there could be a better way to do this, but this works so whatever
  (general-define-key
    ;; NOTE evil-ex-map is different from evil-ex-search-keymap
    :keymaps 'evil-ex-search-keymap
    ;; C-v should paste clipboard contents
    "C-v" 'yank)

  ;; global
  (general-define-key
    ;; more traditional zoom keys
    "C-=" 'text-scale-increase
    "C--" 'text-scale-decrease
    "C-M-=" 'zoom-in
    "C-M--" 'zoom-out

     ;; C-v to paste (or "yank" in emacs jargon) from clipboard, useful for minibuffers (such as query-replace and M-x)
    "C-v" 'yank

    ;; buffer management
    ;; TODO figure this out
    "C-a" 'bury-buffer
    "C-S-a" 'unbury-buffer

    ;; tab cycling
    "C-<tab>" '+tab-bar/switch-to-next-tab
    "C-<iso-lefttab>" '+tab-bar/switch-to-prev-tab
    "C-S-<tab>" '+tab-bar/switch-to-prev-tab
    "<backtab>" '+tab-bar/switch-to-recent-tab

    ;; quick tab switching
    "M-1" (lambda () (interactive) (+tab-bar/switch-by-index 0))
    "M-2" (lambda () (interactive) (+tab-bar/switch-by-index 1))
    "M-3" (lambda () (interactive) (+tab-bar/switch-by-index 2))
    "M-4" (lambda () (interactive) (+tab-bar/switch-by-index 3))
    "M-5" (lambda () (interactive) (+tab-bar/switch-by-index 4))
    "M-6" (lambda () (interactive) (+tab-bar/switch-by-index 5))
    "M-7" (lambda () (interactive) (+tab-bar/switch-by-index 6))
    "M-8" (lambda () (interactive) (+tab-bar/switch-by-index 7))
    "M-9" (lambda () (interactive) (+tab-bar/switch-by-index 8)))

  ;; magit
  (general-define-key
    ;; https://github.com/emacs-evil/evil-magit/issues/14#issuecomment-626583736
    :keymaps 'transient-base-map
    "<escape>" 'transient-quit-one)

  ;; magit keybindings
  ;; TODO refactor within use-package
  (general-define-key
    :states '(normal visual)
    :keymaps 'magit-mode-map
    ;; rebind "q" in magit-status to kill the magit buffers instead of burying them
    "q" '+magit/quit

    ;; tab switching within magit
    "M-1" (lambda () (interactive) (+tab-bar/switch-by-index 0))
    "M-2" (lambda () (interactive) (+tab-bar/switch-by-index 1))
    "M-3" (lambda () (interactive) (+tab-bar/switch-by-index 2))
    "M-4" (lambda () (interactive) (+tab-bar/switch-by-index 3))
    "M-5" (lambda () (interactive) (+tab-bar/switch-by-index 4))
    "M-6" (lambda () (interactive) (+tab-bar/switch-by-index 5))
    "M-7" (lambda () (interactive) (+tab-bar/switch-by-index 6))
    "M-8" (lambda () (interactive) (+tab-bar/switch-by-index 7))
    "M-9" (lambda () (interactive) (+tab-bar/switch-by-index 8)))

  ;; org mode specific evil binding
  ;; unbind the return (enter) key so it becomes org-return
  ;; the return key is not that useful here anyways
  (general-define-key
    :states 'motion
    :keymaps 'org-mode-map
    :major-modes t
    "RET" 'org-return))
;;----

;; PROJECT
;; projectile
(use-package projectile
             :init
             ;; some configs that doom uses https://github.com/doomemacs/doomemacs/blob/bc32e2ec4c51c04da13db3523b19141bcb5883ba/core/core-projects.el#L29
  (setq projectile-auto-discover nil ;; too slow to discover projects automatically, use `projectile-discover-projects-in-search-path' instead
        projectile-enable-caching t  ;; big performance boost, especially for `projectile-find-file'
        projectile-globally-ignored-files '(".DS_Store" "TAGS")
        projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o")
        projectile-project-search-path '("~/Documents/Code"))
             :config
  (projectile-mode +1))
;;----

(use-package neotree
  :ensure t
  )


(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  )

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t
  )

(setq electric-pair-inhibit-predicate
      (lambda (c)
        (if (or (char-equal c ?<)
                (char-equal c ?>))
            t
          (electric-pair-default-inhibit c))))
; https://www.emacswiki.org/emacs/AutoIndentation
(electric-indent-mode 1)
(electric-pair-mode 1)


;; Enable nice rendering of diagnostics like compile errors.
; TODO: refactor
(use-package flycheck
  :init (global-flycheck-mode)

  ;:vc t
  ;:load-path flycheck-path
  )
(use-package consult-flycheck)

;; lsp-mode supports snippets, but in order for them to work you need to use yasnippet
;; If you don't want to use snippets set lsp-enable-snippet to nil in your lsp-mode settings
;; to avoid odd behavior with snippets and indentation
;; Use company-capf as a completion provider.
;;
;; To Company-lsp users:
;;   Company-lsp is no longer maintained and has been removed from MELPA.
;;   Please migrate to company-capf.

; -- legacy
(use-package company
  :hook (scala-mode . company-mode)
  :config
  (setq lsp-completion-provider :capf)
   (setq company-idle-delay 0.1
company-minimum-prefix-length 1
                )
  )
;; (use-package projectile
;;   )
;; (projectile-mode +1)

(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
; -- legacy END

; -------------------------------------------------
;; Enable scala-mode for highlighting, indentation and motion commands
(use-package scala-mode
            :interpreter ("scala" . scala-mode))
;;; Enable sbt mode for executing sbt commands
(use-package sbt-mode
 :commands sbt-start sbt-command
 :config
 ;; WORKAROUND: https://github.com/ensime/emacs-sbt-mode/issues/31
 ;; allows using SPACE when in the minibuffer
 (substitute-key-definition
  'minibuffer-complete-word
  'self-insert-command
  minibuffer-local-completion-map)
  ;; sbt-supershell kills sbt-mode:  https://github.com/hvesalai/emacs-sbt-mode/issues/152
  (setq sbt:program-options '("-Dsbt.supershell=false")))


(use-package lsp-mode
  ;; Optional - enable lsp-mode automatically in scala files
  ;; You could also swap out lsp for lsp-deffered in order to defer loading
  :hook
         (scala-mode . lsp)
         (elixir-mode . lsp)
         (python-mode . lsp)
         (lsp-mode . lsp-lens-mode)
  :config
        (setq lsp-elixir-server-command (list (concat user-home-directory "/src/elixir/ex_packages/expert/apps/expert/_build/prod/rel/plain/bin/start_expert") "--stdio"))

  ;; Uncomment following section if you would like to tune lsp-mode performance according to
  ;; https://emacs-lsp.github.io/lsp-mode/page/performance/
  ;; (setq gc-cons-threshold 100000000) ;; 100mb
  ;; (setq read-process-output-max (* 1024 1024)) ;; 1mb
  ;; (setq lsp-idle-delay 0.500)
  ;; (setq lsp-log-io nil)
  ;; (setq lsp-completion-provider :capf)
  (setq lsp-prefer-flymake nil)
  ;; Makes LSP shutdown the metals server when all buffers in the project are closed.
  ;; https://emacs-lsp.github.io/lsp-mode/page/settings/mode/#lsp-keep-workspace-alive
  (setq lsp-keep-workspace-alive nil)
  )

;; Add metals backend for lsp-mode
(use-package lsp-metals
             :ensure t
             :custom
             ;; You might set metals server options via -J arguments. This might not always work, for instance when
             ;; metals is installed using nix. In this case you can use JAVA_TOOL_OPTIONS environment variable.
                     (lsp-metals-server-args '(;; Metals claims to support range formatting by default but it supports range
                                             ;; formatting of multiline strings only. You might want to disable it so that
                                             ;; emacs can use indentation provided by scala-mode.
                                               "-J-Dmetals.allow-multiline-string-formatting=off"
                                               ;; Enable unicode icons. But be warned that emacs might not render unicode
                                               ;; correctly in all cases.
                                               "-J-Dmetals.icons=unicode"))
             ;; In case you want semantic highlighting. This also has to be enabled in lsp-mode using
             ;; `lsp-semantic-tokens-enable' variable. Also you might want to disable highlighting of modifiers
             ;; setting `lsp-semantic-tokens-apply-modifiers' to `nil' because metals sends `abstract' modifier
             ;; which is mapped to `keyword' face.
             ; https://github.com/emacs-lsp/lsp-metals/blob/master/lsp-metals.el#L363-L386
             (lsp-metals-enable-semantic-highlighting t)
             (lsp-metals-inlay-hints-enable-inferred-types t)
             (lsp-metals-inlay-hints-enable-implicit-conversions t)
             (lsp-metals-inlay-hints-enable-implicit-arguments t)
             (lsp-metals-inlay-hints-enable-type-parameters t)
             (lsp-metals-inlay-hints-enable-hints-in-pattern-match t)
             (lsp-metals-enable-indent-on-paste t)

             :hook (scala-mode . lsp)
             )

;; Enable nice rendering of documentation on hover
;;   Warning: on some systems this package can reduce your emacs responsiveness significally.
;;   (See: https://emacs-lsp.github.io/lsp-mode/page/performance/)
;;   In that case you have to not only disable this but also remove from the packages since
;;   lsp-mode can activate it automatically.
(use-package lsp-ui)

;; (add-hook 'scala-mode-hook
;;   (lambda ()
;;     (electric-indent-local-mode 1)
;;     (setq scala-indent:align-parameters t)
;;     (setq scala-indent:align-forms t)
;;     (setq scala-indent:previous-indent-pos t)
;;     (setq scala-indent:default-run-on-strategy scala-indent:operator-strategy)))

;; ;; Use tabs for indentation in scala-mode
;; (add-hook 'scala-mode-hook
;;           (lambda ()
;;             (setq indent-tabs-mode t)    ;; Use tabs instead of spaces
;;             (setq tab-width 4)           ;; Set tab width (adjust as needed)
;;             (setq scala-indent:use-javadoc-style nil))) ;; Optional: disable javadoc style

; https://emacs-lsp.github.io/lsp-mode/tutorials/clojure-guide/
(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-minimum-prefix-length 1
      ; lsp-enable-indentation nil ; uncomment to use cider indentation instead of lsp
      ; lsp-enable-completion-at-point nil ; uncomment to use cider completion instead of lsp
      )

(unless (package-installed-p 'clojure-mode)
  (package-install 'clojure-mode))

(use-package clojure-mode
  :ensure
  )
(use-package lsp-treemacs
  :ensure
  )
(use-package cider
  :ensure
  )

(setq lsp-enable-completion-at-point nil) ; use cider completion
;(setq cider-eldoc-display-for-symbol-at-point nil) ; disable cider showing eldoc during symbol at point
(setq lsp-eldoc-enable-hover nil) ; disable lsp-mode showing eldoc during symbol at point

(add-hook 'clojure-mode-hook
          (lambda ()
            (modify-syntax-entry ?@ "w" clojure-mode-syntax-table)
            (modify-syntax-entry ?$ "w" clojure-mode-syntax-table)
            (modify-syntax-entry ?- "w" clojure-mode-syntax-table)

            ))


(add-hook 'clojure-mode-hook 'lsp)
(add-hook 'clojurescript-mode-hook 'lsp)
(add-hook 'clojurec-mode-hook 'lsp)

(add-hook 'clojure-mode-hook #'cider-mode)

;; (You may want to do this as a setq-local within a clojure-mode-hook instead)
(custom-set-variables '(company-auto-update-doc t))

(setq cider-storm-path (concat user-home-directory "/src/emacs/packages-src/clojure/cider-storm/"))
(use-package cider-storm
  :ensure
  :vc t
  :load-path cider-storm-path
)
;; (add-to-list 'cider-jack-in-nrepl-middlewares "flow-storm.nrepl.middleware/wrap-flow-storm")

(use-package clj-decompiler
  :ensure
  )

(use-package clj-refactor
  :ensure
  )

(use-package cider-hydra
  :ensure
  )

(use-package flycheck-clj-kondo
  :ensure
  )

;; (use-package sayid
;;   :ensure
;;   )

;; (use-package clay
;;   :ensure
;;   )

; https://shaunlebron.github.io/parinfer/
;; (use-package parinfer-rust-mode
;;   :ensure
;;   )
;; (add-hook 'emacs-lisp-mode 'parinfer-rust-mode)
;; (add-hook 'clojure-mode 'parinfer-rust-mode)

;; (use-package paredit
;;   :ensure
;;   :hook (prog-mode ))

;; (add-hook 'cider-repl-mode-hook #'subword-mode)
;; (add-hook 'cider-repl-mode-hook #'paredit-mode)
;; (define-key paredit-mode-map (kbd "RET") nil)

;; (use-package paren-face
;;   :ensure
;;   )

;; (use-package smartparens
;;   :ensure smartparens  ;; install the package
;;   ;:hook (prog-mode text-mode markdown-mode) ;; add `smartparens-mode` to these hooks
;;   :config
;;   ;; load default config
;;   (require 'smartparens-config))

;; ;; (add-hook 'cider-repl-mode-hook #'smartparens-strict-mode)
;; (add-hook 'prog-mode-hook #'smartparens-strict-mode)

; ----------------------------------------------------------------------------------
(use-package symex-core
  :ensure t
  )
(use-package symex
  :ensure t
  :after (symex-core)
  :config
  (symex-mode 1)
  ;(global-set-key (kbd "C-s-;") #'symex-mode-interface)
  )  ; or whatever keybinding you like
(use-package symex-ide
  :ensure t
  :after (symex)
  :config
  (symex-ide-mode 1))

(use-package symex-evil
  :ensure t
  :after (symex evil)
  :config
  (symex-evil-mode 1))

;;   ;; (symex-core
;;   ;;  :host github
;;   ;;  :repo "drym-org/symex.el"
;;   ;;  :files ("symex-core/symex*.el")
;;   ;;  )

;;   )

;; (use-package symex
;;   :after (symex-core)
;;   :straight
;;   `(symex
;;     :host nil
;;     :type git
;;     :repo ,symex-path
;;    :files ("symex/symex*.el" "symex/doc/*.texi" "symex/doc/figures"))
;;   :config
;;   (symex-mode 1)
;;   ;(global-set-key (kbd "C-s-;") #'symex-mode-interface)
;;   )  ; or whatever keybinding you like

;; (use-package symex-ide
;;   :after (symex)
;;   :straight
;;   `(symex-ide
;;     :host nil
;;     :type git
;;     :repo ,symex-path
;;    :files ("symex-ide/symex*.el"))
;;   :config
;;   (symex-ide-mode 1))

;; (use-package symex-evil
;;   :after (symex evil)
;;   :straight
;;   `( symex-evil
;;     :host nil
;;     :type git
;;     :repo ,symex-path
;;    :files ("symex-evil/symex*.el"))
;;   :config
;;   (symex-evil-mode 1))
; ----------------------------------------------------------------------------------

(use-package rainbow-delimiters
  :ensure
  )

(add-hook 'cider-repl-mode-hook #'rainbow-delimiters-mode)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

;; (use-package eval-sexp-fu
;;   :ensure
;;   )
;; (use-package cider-eval-sexp-fu
;;   :ensure
;;   )
;; (require 'cider-eval-sexp-fu)

(use-package lsp-pyright
  :ensure t
  :custom (lsp-pyright-langserver-command "basedpyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp))))  ; or lsp-deferred

(setq-default flycheck-disabled-checkers '(python-flake8 python-pylint python-pycompile python-pyright python-mypy ))

(use-package elixir-mode
:ensure t
 :hook (elixir-mode . (lambda ()
    (push '(">=" . ?\u2265) prettify-symbols-alist)
    (push '("<=" . ?\u2264) prettify-symbols-alist)
    (push '("!=" . ?\u2260) prettify-symbols-alist)
    (push '("==" . ?\u2A75) prettify-symbols-alist)
    (push '("=~" . ?\u2245) prettify-symbols-alist)
    (push '("<-" . ?\u2190) prettify-symbols-alist)
    (push '("->" . ?\u2192) prettify-symbols-alist)
    (push '("<-" . ?\u2190) prettify-symbols-alist)
    (push '("|>" . ?\u25B7) prettify-symbols-alist))))

;; Assumes web-mode and elixir-mode are already set up
;;
(use-package polymode
  :mode ("\.ex$" . poly-elixir-web-mode)
  :config
  (define-hostmode poly-elixir-hostmode :mode 'elixir-mode)
  (define-innermode poly-liveview-expr-elixir-innermode
    :mode 'web-mode
    :head-matcher (rx line-start (* space) "~H" (= 3 (char "\"'")) line-end)
    :tail-matcher (rx line-start (* space) (= 3 (char "\"'")) line-end)
    :head-mode 'host
    :tail-mode 'host
    :allow-nested nil
    :keep-in-mode 'host
    :fallback-mode 'host)
  (define-polymode poly-elixir-web-mode
    :hostmode 'poly-elixir-hostmode
    :innermodes '(poly-liveview-expr-elixir-innermode))
  )
(setq web-mode-engines-alist '(("elixir" . "\\.ex\\'")))

(use-package exunit
:ensure t
  )
(add-hook 'elixir-mode-hook 'exunit-mode)
;; Optionally configure `transient-default-level' to 5 to show extra switches
;; Or use `C-x l' to change the level of individual commands and switches
(setq transient-default-level 5) ;; default is 4
(use-package web-mode
:ensure t
  )

(setq lsp-elixir-ls-download-url nil)
(setq lsp-elixir-mix-env 'dev)

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

(setq lsp-mark 'emacsd-lsp)

; lspheaderline
;https://emacs-lsp.github.io/lsp-mode/page/settings/headerline/#lsp-headerline-breadcrumb-enable-diagnostics
(setq lsp-headerline-breadcrumb-enable-diagnostics nil)

(defun my/logseq ()
  (plz 'post "http://127.0.0.1:12315/api"
  :headers '(
             ("Content-Type" . "application/json")
             ("Authorization" . "aa")
             )
  :body (json-encode '(("method" . "logseq.Editor.getCurrentBlock")))
  :as #'json-read
  :then (lambda (alist)
          (message "Result: %s" (alist-get 'uuid alist))
          (setq my-logseq-current-block-uuid (alist-get 'uuid alist))
          (my/create-org-buffer-with-text (alist-get 'content alist))
                ))
  )
  (defun my/org-paragraph-at-point ()
    (save-excursion
     (let ((beg (progn (org-backward-paragraph) (point)))
            (end (progn (org-forward-paragraph) (point))))
       (buffer-substring-no-properties beg end))))

  (defun my/message ()
    ;(message (my/org-paragraph-at-point))
    ;(setq muuid "x111111")

     ;(let* ((json-string (json-encode (list (cons "key" "value"))))

    (shell-command "xdotool key Super_L+l && xdotool key ctrl+bracketleft")

    (sleep-for 0.2)

     (plz 'post "http://127.0.0.1:12315/api"
          ;"http://localhost:9999/"
          :headers '(
                     ("Content-Type" . "application/json")
                     ("Authorization" . "aa")
                     )
          :body (json-encode (list
                               (cons "method"  "logseq.Editor.updateBlock")
                               (cons "args"  (list
                                           my-logseq-current-block-uuid
                                            ;muuid
                                           ;"69778702-c5f5-4487-bf7b-e1c2de5ea0d1"
                                            ;"siiii"
                                           (my/org-paragraph-at-point)
                                              ))
                                       ))

     :then (lambda (response)
                   ;(message (plz-response-status response))
                   (sleep-for 0.3)
                   (shell-command "xdotool key Super_L+l && xdotool key ctrl+bracketright")
                   )
     )
  )


  (defun my/create-org-buffer-with-text (text)
    "Create a new buffer in org-mode and insert TEXT."
    (let* (
           (buf (generate-new-buffer "*org-text*"))
           ;(text "mama mia")
           )
      (switch-to-buffer buf)
      (org-mode)
      (insert text)))
