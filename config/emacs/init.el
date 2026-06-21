;;;; init.el -*- lexical-binding: t; -*-
;;;;
;;;
;;; A fledging bird's emacs config
;;;
;;;    ⠀⠀⠀⠀⠀⠀⢀⣠⠴⠒⠒⠒⠒⠒⠶⠦⠤⠴⠒⠚⠉⣰⠟⠁⠀⠀⠀⠀⠀⠀
;;;    ⠀⠀⠀⠀⢀⡞⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠒⡿⠃⠀⠀⠀⠀⠀⠀⠀⠀
;;;    ⠀⠀⠀⢠⡿⣤⣄⠀⠀⠀⠀⠀⢀⣤⣄⠀⠀⠀⣰⠞⠁⠀⠀⠀⢠⣤⠀⠀⠀⠀
;;;    ⠀⠀⢠⡟⠸⣿⡿⢀⠤⢄⠀⠐⣷⣿⣿⡷⠀⠀⢻⠀⠀⠀⢀⡴⠋⠘⡇⠀⠀⠀
;;;    ⠀⠀⢸⠈⠲⡬⢠⡏⠀⢀⡷⠀⠨⣭⠭⠖⣇⠀⣾⠀⠀⡴⠋⠀⠀⠀⣧⠀⠀⠀
;;;    ⠀⠀⢸⣷⠞⠁⠀⠳⠖⠋⠀⠀⠀⠙⠶⠶⠃⡼⢿⣠⠎⠀⠀⠀⠀⠀⣿⠀⠀⠀
;;;    ⠀⠀⢸⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠃⠀⠀⠀⠀⠀⠀⡟⠀⠀⠀
;;;    ⠀⠀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡄⠀⠀⠀⠀⠀⢠⠃⠀⠀⠄
;;;    ⢀⣰⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠉⠉⠉⠉⠲⢄⡀⢀⣠⡷⠀⠀⢠
;;;    ⢸⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠧⠤⢾⢀⠏
;;;    ⢸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢨⠏⠀
;;;    ⢸⠀⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡏⠀⠀
;;;    ⠈⢷⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠢⡀⠀⠀⠀⠀⠀⠀⢀⣤⡏⠀⠀⠀
;;;    ⠀⠈⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⠲⠶⠶⠖⠊⠁⣴⠇⠀⠀⠀
;;;    ⠀⠀⠘⢧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠁⠀⠀⠀⠀
;;;    ⠀⠀⠀⠈⠻⢦⣀⠀⠀⠀⠀⠀⠀⣠⣎⡀⡀⠀⠀⣀⣰⢶⠶⠚⠁⠀⠀⠀⠀⠀
;;;    ⠀⠀⠀⠀⣰⠛⠉⡙⠛⢛⣷⠖⠒⢖⣾⠟⢛⠛⠺⣿⣏⠁⠀⠀⠀⠀⠀⠀⠀⠀
;;;
;;;;
;;;; Be forewarned, I have no idea what I am doing...
;;;;
;;;; I use package.el for configuration, I think it is good enough for me right
;;;; now. In general, I avoid :init and :custom as much as possible unless
;;;; it is to set some values.
;;;;
;;;; :custom is avoided because it for some reason slows startup, I think there
;;;; is a distinction between :custom and :config, namely setq vs setopt but I am
;;;; too much of a fledging to understand its consequences for now...
;;;;
;;;; Since I don't want to deal with org mode and tangling, I instead opt for
;;;; providing descriptions in the comments. Each section has a "flag" which can
;;;; easily be searched for, like this: |* Section.
;;;;
;;;; For :hook, I avoid the shorthand for consistency so even if :hook (blah)
;;;; works, I would type out :hook (blah . pack-mode).

;;;; ------------------------- Start of the init file ----------------------------
;;;; Package.el
;;
;; Add MELPA, always defer packages, and always ensure 
(setq use-package-always-defer t
      use-package-always-ensure t)
(with-eval-after-load 'package (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t))

;;;; Doomemacs
;;
;; From doomemacs, adds :defer-incremental and :after-call to use-package
;; https://github.com/hlissner/doom-emacs/blob/42a21dffddeee57d84e82a9f0b65d1b0cba2b2af/core/core.el#L353
(defvar doom-incremental-packages '(t)
  "A list of packages to load incrementally after startup. Any large packages
here may cause noticeable pauses, so it's recommended you break them up into
sub-packages. For example, `org' is comprised of many packages, and can be
broken up into:
  (doom-load-packages-incrementally
   '(calendar find-func format-spec org-macs org-compat
     org-faces org-entities org-list org-pcomplete org-src
     org-footnote org-macro ob org org-clock org-agenda
     org-capture))
This is already done by the lang/org module, however.
If you want to disable incremental loading altogether, either remove
`doom-load-packages-incrementally-h' from `emacs-startup-hook' or set
`doom-incremental-first-idle-timer' to nil.")

(defvar doom--deferred-packages-alist '(t))

(defvar doom-incremental-first-idle-timer 2.0
  "How long (in idle seconds) until incremental loading starts.
Set this to nil to disable incremental loading.")

(defvar doom-incremental-idle-timer 0.75
  "How long (in idle seconds) in between incrementally loading packages.")

(defvar doom-incremental-load-immediately nil
  ;; (daemonp)
  "If non-nil, load all incrementally deferred packages immediately at startup.")
  
(defvar doom-inhibit-log (not (or noninteractive init-file-debug))
  "If non-nil, suppress `message' output.")

(defmacro appendq! (sym &rest lists)
  "Append LISTS to SYM in place."
  `(setq ,sym (append ,sym ,@lists)))
  
(defmacro delq! (elt list &optional fetcher)
  "`delq' ELT from LIST in-place.

If FETCHER is a function, ELT is used as the key in LIST (an alist)."
  `(setq ,list (delq ,(if fetcher
                          `(funcall ,fetcher ,elt ,list)
                        elt)
                     ,list)))
		     
(defun doom-load-packages-incrementally (packages &optional now)
  "Registers PACKAGES to be loaded incrementally.
If NOW is non-nil, load PACKAGES incrementally, in `doom-incremental-idle-timer'
intervals."
  (if (not now)
      (appendq! doom-incremental-packages packages)
    (while packages
      (let ((req (pop packages)))
        (unless (featurep req)
          (message "Incrementally loading %s" req)
          (condition-case e
              (or (while-no-input
                    ;; If `default-directory' is a directory that doesn't exist
                    ;; or is unreadable, Emacs throws up file-missing errors, so
                    ;; we set it to a directory we know exists and is readable.
                    (let ((default-directory user-emacs-directory)
                          (gc-cons-threshold most-positive-fixnum)
                          file-name-handler-alist)
                      (require req nil t))
                    t)
                  (push req packages))
            ((error debug)
             (message "Failed to load '%s' package incrementally, because: %s"
                      req e)))
          (if (not packages)
              (message "Finished incremental loading")
            (run-with-idle-timer doom-incremental-idle-timer
                                 nil #'doom-load-packages-incrementally
                                 packages t)
            (setq packages nil)))))))

(defun doom-load-packages-incrementally-h ()
  "Begin incrementally loading packages in `doom-incremental-packages'.
If this is a daemon session, load them all immediately instead."
  (if doom-incremental-load-immediately
      (mapc #'require (cdr doom-incremental-packages))
    (when (numberp doom-incremental-first-idle-timer)
      (run-with-idle-timer doom-incremental-first-idle-timer
                           nil #'doom-load-packages-incrementally
                           (cdr doom-incremental-packages) t))))
(add-hook 'emacs-startup-hook #'doom-load-packages-incrementally-h)

;; Adds two keywords to `use-package' to expand its lazy-loading capabilities:
;;
;;   :after-call SYMBOL|LIST
;;   :defer-incrementally SYMBOL|LIST|t
;;
;; Check out `use-package!'s documentation for more about these two.
(with-eval-after-load 'use-package-core
  (dolist (keyword '(:defer-incrementally :after-call))
    (push keyword use-package-deferring-keywords)
    (setq use-package-keywords
          (use-package-list-insert keyword use-package-keywords :after)))

  (defalias 'use-package-normalize/:defer-incrementally #'use-package-normalize-symlist)
  (defun use-package-handler/:defer-incrementally (name _keyword targets rest state)
    (use-package-concat
     `((doom-load-packages-incrementally
        ',(if (equal targets '(t))
	      (list name)
            (append targets (list name)))))
     (use-package-process-keywords name rest state)))
  
  (defalias 'use-package-normalize/:after-call #'use-package-normalize-symlist)
  (defun use-package-handler/:after-call (name _keyword hooks rest state)
    (if (plist-get state :demand)
        (use-package-process-keywords name rest state)
      (let ((fn (make-symbol (format "doom--after-call-%s-h" name))))
        (use-package-concat
         `((fset ',fn
                 (lambda (&rest _)
                   (message "use-package: lazy loading %s from %s" ',name ',fn)
                   (condition-case e
		       ;; If `default-directory' is a directory that doesn't
		       ;; exist or is unreadable, Emacs throws up file-missing
		       ;; errors, so we set it to a directory we know exists and
		       ;; is readable.
		       (let ((default-directory user-emacs-directory))
                         (require ',name))
                     ((debug error)
		      (message "Failed to load deferred package %s: %s" ',name e)))
                   (when-let (deferral-list (assq ',name doom--deferred-packages-alist))
                     (dolist (hook (cdr deferral-list))
		       (advice-remove hook #',fn)
		       (remove-hook hook #',fn))
                     (delq! deferral-list doom--deferred-packages-alist)
                     (unintern ',fn nil)))))
         (let (forms)
           (dolist (hook hooks forms)
             (push (if (string-match-p "-\\(?:functions\\|hook\\)$" (symbol-name hook))
		       `(add-hook ',hook #',fn)
                     `(advice-add #',hook :before #',fn))
                   forms)))
         `((unless (assq ',name doom--deferred-packages-alist)
             (push '(,name) doom--deferred-packages-alist))
           (nconc (assq ',name doom--deferred-packages-alist)
                  '(,@hooks)))
         (use-package-process-keywords name rest state))))))

;;;; Defaults 
(use-package emacs
  :ensure nil
  :demand t
  :init
  (setq-default fill-column 80
		;; Wrap preserves words
		word-wrap t
		;; Truncate lines by default, enable 'visual-line-mode' for wrapping
		truncate-lines t)
  ;; Default wrap in 'text-mode'
  (add-hook 'text-mode-hook #'visual-line-mode)
  ;; Automagically chmods executable files
  (add-hook 'after-save-hook
	    #'executable-make-buffer-file-executable-if-script-p)
  ;; https://github.com/doomemacs/doomemacs/blob/01aadd8900be45f912124d9d815d8790f540d38c/core/core.el#L177
  (setq idle-update-delay 1)
  ;; Fonts
  (add-to-list 'default-frame-alist '(font ."FantasqueSansM Nerd Font Mono-20"))
  ;; Behavior
  (setq use-file-dialog nil
	;; I find these clunky to use, and backups of the files themselves can be
	;; potentially dangerous to have floating around.
	make-backup-files nil
	create-lockfiles nil

	;; No need to have duplicates...
	kill-do-not-save-duplicates t

	;; Never show tab-bar
	tab-bar-show nil

	;; Ignore case
	read-file-name-completion-ignore-case t
	read-buffer-completion-ignore-case t
	completion-ignore-case t

	;; Vertical splits over horizontal ones
	split-width-threshold nil
	split-height-threshold 160

	;; Scrolling and scroll off
	scroll-step 1
	auto-window-vscroll nil
	scroll-margin 7

	;; Silence native comp errors
	native-comp-async-report-warnings-errors nil

	;; Move custom stuff elsewhere and don't load them, I prefer
	;; customizing through code. This cause problems down the road...
	custom-file "~/.config/emacs/custom.el"

	;; Don't render stuff in inactive windows, distracting...
	cursor-in-non-selected-windows nil
	highlight-nonselected-windows nil

	;; Automatically select help window when opening it
	help-window-select t

	;; Don't look up hostnames when using ffap (gf for vim)
	ffap-machine-p-known 'reject

	;; Answer yes-no-prompts using just y or n
	use-short-answers t)
  ;; Don't map space to yes for the prompt
  (define-key y-or-n-p-map " " nil)

  ;; No blinking cursor. Also set highlighted cursor line
  (blink-cursor-mode -1)
  (setq window-divider-default-bottom-width 24
	window-divider-default-right-width 24)
  (add-hook 'on-init-ui-hook #'window-divider-mode)

  ;; Set encoding
  (set-language-environment "UTF-8")
  (setq default-input-method nil)

  ;; Completion menus (vertico and corfu)
  ;; For corfu, note that 'complete removes inserting tabs... a hefty price
  ;; But you can still indent so it is fine: indent with tabs align with spaces
  (setq tab-always-indent 'complete
	text-mode-ispell-word-completion nil
	;; Enable context menu. `vertico-multiform-mode' adds a menu in the minibuffer
	;; to switch display modes.
	;; Support opening new minibuffers from inside existing minibuffers.
	context-menu-mode t
	enable-recursive-minibuffers t
	;; Hide commands in M-x which do not work in the current mode.  Vertico
	;; commands are hidden in normal buffers. This setting is useful beyond
	;; Vertico.
	read-extended-command-predicate #'command-completion-default-include-p
	;; Do not allow the cursor in the minibuffer prompt
	minibuffer-prompt-properties '(read-only t cursor-intangible t face minibuffer-prompt))

  ;; Properly deletes tabs
  (setq backward-delete-char-untabify-method nil)

  ;; Performance!!!!!!
  ;; Most of these were pilfered from Doom. Not really needed, disabling saves
  ;; some time.
  (setq auto-mode-case-fold nil)
  ;; Don't really use these so setting these should be fine
  (setq bidi-inhibit-bpa t)
  (setq-default bidi-display-reordering 'left-to-right
		bidi-paragraph-direction 'left-to-right)
  ;; Helps with scrolling performance
  (setq redisplay-skip-fontification-on-input t)

  ;; I actually have no idea how to work this
  (setq display-buffer-alist
	'(
	  ;; Make warnings, logs, and erros open on the bottom
	  ("\\*\\(?:Warnings\\|Compile-Log\\|Flymake diagnostics.*\\)\\*"
	   (display-buffer-in-side-window)
	   (window-height . 0.30)
	   (side . bottom)
	   (direction . below)
	   (slot . -1)
	   (window-parameters . ((split-window . #'ignore))))
	  ("\\*.*\\-eat\\*"
	   (display-buffer-at-bottom)
	   (window-height . 0.30)
	   (side . right)
	   (direction . below)
	   (window-parameters . ((split-window . #'ignore))))
	  ;; Preview pdfs in the sidebar
	  ;; ("\\.pdf\\'"
	  ((major-mode . pdf-view-mode)
	   (display-buffer-reuse-mode-window display-buffer-in-side-window)
	   (window-width . 0.45)
	   (side . right)
	   (slot . 1)))))

;;;; General
;;
;; Use general for keybindings. As recommended, :general is used for
;; keybinds which load the package, and :general-config is used for
;; everything else. In practice I prefer :config over :general-config.
;; I defined two leaderkeys: <space> which is available all the time and
;; <space>l, the localleader, which has different keybinds depending on
;; the current major mode
(use-package general
  ;; This module is needed immediately, everything depends on it since it is
  ;; used for keybindings via :general and :general-config.
  :demand t
  :config
  ;; Leader keys, set to space by default
  (general-create-definer leader-keys
    :states '(normal visual)
    :keymaps 'override
    :prefix "SPC")
  (general-create-definer localleader-keys
    :states '(normal visual)
    :prefix "SPC l"))

;;;; On
;;
;; Little package to add extra hooks like on-first-input and
;; on-init-ui-hook. This mirrors doom emacs style and prevents blanket
;; after-init-hooks. Load immediately so the hooks are available.
(use-package on :demand t)

;;;; Colorscheme
(use-package kanagawa-themes
  :demand t
  :config
  (setq kanagawa-themes-comment-italic t)
  (load-theme 'kanagawa-dragon t)
  (set-face-background 'header-line "#1d1c19")
  (set-face-background 'mode-line-active "#1d1c19")
  (set-face-background 'mode-line-inactive "#1d1c19")

  ;; TODO: generalize this
  (dolist (face '(window-divider
		  window-divider-first-pixel
		  window-divider-last-pixel))
    (set-face-attribute face nil :foreground "#181616"))

  (with-eval-after-load 'diff-hl
    (set-face-attribute 'diff-hl-insert nil :foreground "#87a987" :background "unspecified")
    (set-face-attribute 'diff-hl-change nil :foreground "#e6c384" :background "unspecified")
    (set-face-attribute 'diff-hl-delete nil :foreground "#e46876" :background "unspecified")))

;;;; Builtin 
;;
;; These are built-in, the configurations here just tweak them so they either
;; become cooler or are lazyloaded. Included are
;;   which-key: the non-evil version of the witch-key  
;;   dired: browsing files in dire situations
;;   project: looking at eternally unfinished projects
;;   eshell: for when `eat is too gluttonous
;;   flymake: making things on the fly
;;   recentf: recent files for recent stuff
;;   saveplace, savehist: open to last location and persist minibuffer history
;;   hl-line: highlight the current line... that is it
;;   tramp: edit files remotely like a wizard
;;   outline: super simple folding, used for elisp since it works so well
;;   desktop: saves your work for later, so you can eat it later
;;   eglot: occasional lsp sweets 
;;   appt: notifications from emacs, with prophecies from org
;; Changes should be fairly minimal if possible
(use-package which-key
  :ensure nil
  :hook (on-first-input . which-key-mode))
(use-package dired
  :ensure nil
  :commands dired-jump
  :init
  (setq dired-dwim-target t)
  :config
  (setq dired-listing-switches "-Ahl -v --group-directories-first"))
(use-package project
  :ensure nil
  :general
  (leader-keys
    :infix "p"
    "d" '("project diagnostics" . flymake-show-project-diagnostics)
    "r" '("project recompile" . project-recompile)
    "c" '("project compile" . project-compile)
    "p" '("project projects" . project-switch-project)
    "x" '("project kill buffers" . project-kill-buffers)
    "f" '("project files" . project-find-file)
    "s" '("project search" . project-search)))
(use-package eshell
  :ensure nil
  :general
  (leader-keys "oe" '("open eshell" . eshell)))
(use-package flymake
  :ensure nil
  :config
  (setq flymake-show-diagnostics-at-end-of-line t)
  ;; Use config because usually flymake already gets loaded by some other modes
  ;; so we just have to load the keybindings.
  (leader-keys "od" '("open diagnostic" . flymake-show-buffer-diagnostics))
  (general-def 'normal
    "]d" '("next diagnostic" . flymake-goto-next-error)
    "[d" '("previous diagnostic" . flymake-goto-prev-error)))
(use-package recentf
  :ensure nil
  ;; Not going to lie, I have no idea what these are
  :defer-incrementally easymenu tree-widget timer
  :hook (on-first-file-hook . recentf-mode)
  :commands recentf-open-files
  :config
  (setq recentf-auto-cleanup nil
	recentf-max-saved-items 50)
  ;; From doom, don't add string properties (no purpose for them)
  (add-to-list 'recentf-filename-handlers #'substring-no-properties)
  ;; From doom, clean recentf at exit unless it is a daemon 
  (setq recentf-auto-cleanup (if (daemonp) 300))
  (add-hook 'kill-emacs-hook #'recentf-cleanup))
(use-package saveplace
  :ensure nil
  :hook (on-first-file . save-place-mode))
(use-package savehist
  :ensure nil
  :hook (on-first-file . savehist-mode))
(use-package hl-line
  :ensure nil
  :hook (on-first-buffer . global-hl-line-mode))
(use-package tramp-perf
  :ensure nil
  :after tramp
  ;; Most of these are from https://coredumped.dev/2025/06/18/making-tramp-go-brrrr./
  ;; Use scp directly for file copying and prevent tramp from littering files
  ;; TODO: switch over to rysnc eventually
  :config
  (setq remote-file-name-inhibit-locks t
	tramp-use-scp-direct-remote-copying t
	remote-file-name-inhibit-auto-save-visited t)
  ;; Overall best value according to the blog
  (setq tramp-copy-size-limit (* 1024 1024) ;; 1MB
	tramp-verbose 2)
  ;; Use direct async processes for performance and speed
  (connection-local-set-profile-variables
   'remote-direct-async-process
   '((tramp-direct-async-process . t)))
  (connection-local-set-profiles
   '(:application tramp :protocol "scp")
   'remote-direct-async-process)
  ;; Tramp can use SSH connection sharing for faster connections. However
  ;; 'compile' disables that for some reason so we tell tramp to turn it back on
  (with-eval-after-load 'compile
    (remove-hook 'compilation-mode-hook #'tramp-compile-disable-ssh-controlmaster-options))
  ;; TODO: incoporate these somehow
  ;; (remove-hook 'evil-insert-state-exit-hook #'doom-modeline-update-buffer-file-name)
  ;; (remove-hook 'find-file-hook #'doom-modeline-update-buffer-file-name)
  ;; (remove-hook 'find-file-hook 'forge-bug-reference-setup)

  ;; Cache as much values as possible
  (defun memoize-remote (key cache orig-fn &rest args)
    "Memoize a value if the key is a remote path."
    (if (and key
	     (file-remote-p key))
	(if-let ((current (assoc key (symbol-value cache))))
	    (cdr current)
	  (let ((current (apply orig-fn args)))
	    (set cache (cons (cons key current) (symbol-value cache)))
	    current))
      (apply orig-fn args)))
  ;; Memoize current project
  (defvar project-current-cache nil)
  (defun memoize-project-current (orig &optional prompt directory)
    (memoize-remote (or directory
			project-current-directory-override
			default-directory)
		    'project-current-cache orig prompt directory))

  (advice-add 'project-current :around #'memoize-project-current)

  ;; Memoize magit top level
  (defvar magit-toplevel-cache nil)
  (defun memoize-magit-toplevel (orig &optional directory)
    (memoize-remote (or directory default-directory)
                    'magit-toplevel-cache orig directory))
  (advice-add 'magit-toplevel :around #'memoize-magit-toplevel)

  ;; memoize vc-git-root
  (defvar vc-git-root-cache nil)
  (defun memoize-vc-git-root (orig file)
    (let ((value (memoize-remote (file-name-directory file) 'vc-git-root-cache orig file)))
      ;; sometimes vc-git-root returns nil even when there is a root there
      (when (null (cdr (car vc-git-root-cache)))
	(setq vc-git-root-cache (cdr vc-git-root-cache)))
      value))
  (advice-add 'vc-git-root :around #'memoize-vc-git-root))
(use-package outline
  :ensure nil
  :hook (emacs-lisp-mode . outline-minor-mode))

(use-package desktop
  :ensure nil
  :hook (on-init-ui . desktop-save-mode))
(use-package eglot
  :ensure nil
  :config
  (setq eglot-autoshutdown t)
  ;; PERF: from doomemacs
  (cl-callf plist-put eglot-events-buffer-config :size 0)

  (advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
  (defun my/eglot-capf ()
    (setq-local completion-at-point-functions
		(list (cape-capf-super
		       #'eglot-completion-at-point
		       #'tempel-expand))))
  (add-hook 'eglot-managed-mode-hook #'my/eglot-capf))
(use-package eglot-booster
  :vc (:url "https://github.com/jdtsmith/eglot-booster.git" :rev :newest)
  :after eglot
  :init
  (setq eglot-booster-io-only t)
  :config
  (eglot-booster-mode +1))

(use-package appt
  :after org-agenda
  :ensure nil
  :config
  ;; From https://www.reddit.com/r/emacs/comments/1gdjtcf/you_dont_need_orgalert_emacs_has_it_builtin_kinda/
  ;; Specifically from karthink's config
  ;; https://github.com/karthink/.emacs.d/blob/793b1209f493a10068b3c145658364dda5c24e99/lisp/setup-org.el#L1192
  (setq appt-disp-window-function
	(lambda (minutes-to now text)
	  (org-show-notification
	   (format "Appointment in %s minutes:\n%s"
		   minutes-to text)))
	appt-display-interval 15
	appt-display-mode-line nil
	appt-message-warning-time 60)
  (define-advice appt-activate (:after (&optional _arg) hold-your-horses)
    "`appt-activate' is too eager, rein it in."
    (remove-hook 'write-file-functions #'appt-update-list)
    (when (timerp appt-timer)
      (timer-set-time appt-timer (current-time) 3000)))
  (define-advice appt-check (:before (&optional _force) from-org-agenda)
    "Read events from Org agenda if possible."
    (and (featurep 'org-agenda)
         (ignore-errors
           (let ((inhibit-message t))
             (org-agenda-to-appt t))))))
;;;; Evil
;;
;; Vim emulation via evil, cause life isn't fun without being evil.
;; This is the usual evil stuff with the usual evil modules
;;   evil: the head honcho of evil
;;   evil-commentary: 'gc' to comment (TODO: replace with evil-nerd-commenter?)
;;   evil-surround: 'ys' in normal mode and 'S' in visual mode to surround
;;   evil-collection: halloween goodie bag
;;   evil-numbers: incrementing via 'C-a' and 'C-x', use g before for global incrementing
;;   evil-visualstar: use '*' and '#' on visual selections to search
;;   evil-indent-plus: indentation text objects
;;   evil-matchit: matches vim's matchit
;;   evil-textobj-anyblock: block textobjs and look ahead for them
;;   doom-modeline: sleek modeline, which I placed in the header actually
;;   mini-echo: for showing tabs in the echo-msg area thingy
;;   anzu and evil anzu: anzu, shows search results, used by 'doom-modeline'
;;   better-jumper: more predictable jumping
;;   evil-textobj-tree-sitter: treesitter powered text objects
;; Evil is a constant battle between emacs and evil.
(use-package evil
  ;; This is risky, we have to ensure evil is loaded before other modules
  ;; (except general.el and on.el) of course, but it is not too hard, in
  ;; practice, this should mean anything using emacs-startup hook should load
  ;; after evil, if it depends on evil.
  :hook (on-init-ui . evil-mode)
  :init
  ;; We want these loaded before evil is loaded so set them in init.  Well,
  ;; it is fine for some of them to be loaded later, but ... I am not smart
  ;; enough to know which ones so just load them up front, also more convienent.
  (setq evil-ex-search-vim-style-regexp t
	;; Vim compat
	evil-ex-visual-char-range t
	evil-symbol-word-search t
	evil-want-C-u-scroll t
	;; Y behaves like y$
	evil-want-Y-yank-to-eol t
	evil-respect-visual-line-mode t
	;; Only show highlights in current window
	evil-ex-interactive-search-highlight 'selected-window
	;; Needed for evil-collection
	evil-want-keybinding nil
	;; Don't abort my macros for dumb errors
	evil-kbd-macro-suppress-motion-error t
	evil-undo-system 'undo-redo)
  :config
  ;; Set default states for some buffers
  (evil-set-initial-state 'pdf-view-mode 'normal)
  ;; Don't automatically copy visual selection to clipboard
  (setq evil-visual-update-x-selection-p nil)
  ;; Needed for gn to work
  (evil-select-search-module 'evil-search-module 'evil-search)
  ;; Super-tab behavior
  ;; 1) expand snippet
  ;; 2) if we are inside a snippet, jump to the next field,
  ;; 3) if we are inside a org table, jump to the next field
  ;; 4) fall back to `indent-for-tab-command'
  (defun smarttab ()
    (interactive)
    (cond ((tempel-expand) (1))
	  ((bound-and-true-p tempel--active) (tempel-next 1))
	  ((and (fboundp #'org-at-table-p) (org-at-table-p)) (org-table-next-field))
	  (t (indent-for-tab-command))))
  ;; If in a snippet, jump back, otherwise 
  (defun smartshifttab ()
    (interactive)
    (cond ((bound-and-true-p tempel--active) (tempel-previous 1))
	  ((and (fboundp #'org-at-table-p) (org-at-table-p)) (org-table-previous-field))
	   (t ())))
  ;; Extra insert mode bindings
  (general-def 'insert
    ;; Enter normal mode by entering jk while in insert mode
    "j" (general-key-dispatch 'self-insert-command :timeout 0.25 "k" #'evil-normal-state)
    ;; Paste in insert mode via Ctrl-v (it is normally not too useful)
    "C-v" #'evil-paste-after
    ;; Alternate completion keybind
    "C-SPC" #'completion-at-point
    ;; Overloaded tabbing
    "<tab>"     #'smarttab
    "<backtab>" #'smartshifttab)
    ;; Continue comments
  (general-def 'global-map
    "RET"       #'default-indent-new-line)
  ;; Extra normal mode bindings
  ;; Move windows via C-hjkl, help is rebounded via <leader>h so it is fine to
  ;; remap C-h (I think)
  (general-def 'normal 'override
    "]t" #'tab-next
    "[t" #'tab-previous
    "C-h" #'windmove-left
    "C-j" #'windmove-down
    "C-k" #'windmove-up
    "C-l" #'windmove-right)
  ;; TODO: this breaks some stuff, so uncomment for now
  ;; Make J (evil-join) remove comment delimiters when joining lines.
  ;; This was taken from https://github.com/emacs-evil/evil/issues/606
  ;; (evil-define-operator better-evil-join (beg end)
  ;;   "Join the selected lines."
  ;;   :motion evil-line
  ;;   (let* ((count (count-lines beg end))
  ;; 	   ;; we join pairs at a time
  ;; 	   (count (if (> count 1) (1- count) count))
  ;; 	   ;; the mark at the middle of the joined pair of lines
  ;; 	   (fixup-mark (make-marker)))
  ;;     (dotimes (var count)
  ;; 	(if (and (bolp) (eolp))
  ;; 	    (join-line 1)
  ;; 	  (let* ((end (line-beginning-position 3))
  ;; 		 (fill-column (1+ (- end beg))))
  ;; 	    ;; save the mark at the middle of the pair
  ;; 	    (set-marker fixup-mark (line-end-position))
  ;; 	    ;; join it via fill
  ;; 	    (fill-region-as-paragraph beg end)
  ;; 	    ;; jump back to the middle
  ;; 	    (goto-char fixup-mark)
  ;; 	    ;; context-dependent whitespace fixup
  ;; 	    (fixup-whitespace))))
  ;;     ;; remove the mark
  ;;     (set-marker fixup-mark nil)))
  ;; (advice-add #'evil-join :override #'better-evil-join)
  ;; Core leader bindings

  ;; From Doom, don't move cursor to start of selection after indenting, such as
  ;; when using =i{ to indent inside braces, which without this will move to the
  ;; start of { which is very annoying.
  (define-advice evil-indent (:around (fn &rest args) my-retain-cursor)
    (save-excursion (apply fn args)))

  ;; From Doom, make numbered registers local to buffer, like they are in vim.
  (define-advice evil-global-marker-p (:after-until (char) my-local-numbered-registers)
    (and (>= char ?2) (<= char ?9)))

  (leader-keys
    "t" '("find tabs" . tab-bar-select-tab-by-name)
    "SPC"   '("alt buffer" . evil-switch-to-windows-last-buffer)
    "f"     '("files" . find-file)
    "xb"    '("kill buffer" . kill-current-buffer)
    "xt"    '("kill tab" . tab-close)
    "xm"    '("kill bookmark" . bookmark-delete)
    "ct"    '("create tab" . tab-new)
    "cm"    '("create bookmark" . bookmark-set)
    "pa"    '("project alternate" . ff-find-other-file)
    "hm"    '("help mode" . describe-mode)
    "hv"    '("help variable" . describe-variable)
    "ht"    '("help function" . describe-face)
    "hf"    '("help function" . describe-function)
    "hk"    '("help key" . describe-key)))
(use-package evil-commentary
  :after evil
  :hook (on-first-input . evil-commentary-mode))
(use-package evil-surround
  :after evil
  :hook (on-first-input . global-evil-surround-mode))
(use-package evil-collection
  :after evil
  :hook (evil-mode . evil-collection-init))
(use-package evil-numbers
  :after evil
  :general
  (general-def '(normal visual)
   "C-a"   #'evil-numbers/inc-at-pt
   "C-x"   #'evil-numbers/dec-at-pt
   "g C-a" #'evil-numbers/inc-at-pt-incremental
   "g C-x" #'evil-numbers/dec-at-pt-incremental))
(use-package evil-visualstar :hook (on-first-input . global-evil-visualstar-mode))
(use-package evil-indent-plus :hook (on-first-input . evil-indent-plus-default-bindings))
(use-package evil-matchit :hook (on-first-input . global-evil-matchit-mode))
(use-package evil-textobj-anyblock
  :after evil
  :general
  (:keymaps 'inner "b" #'evil-textobj-anyblock-inner-block)
  (:keymaps 'outer "b" #'evil-textobj-anyblock-a-block)
  :init
  (setq evil-textobj-anyblock-blocks
        '(("(" . ")")
	  ("{" . "}")
          ("\\[" . "\\]")
          ("<" . ">")
	  ("'" . "'")
	  ("\"" . "\"")
	  ("`" . "`")
	  ("“" . "”"))))
(use-package doom-modeline
  :hook (on-init-ui . doom-modeline-mode)
  :init
  ;; Set these early
  (setq doom-modeline-always-show-macro-register t
	doom-modeline-height 40
	doom-modeline-modal-modern-icon nil
	doom-modeline-battery nil
	doom-modeline-irc nil
	doom-modeline-time nil)
  :config
  (setq-default header-line-format '("%e" (:eval (doom-modeline-format--main)))))
;; Make this prettier later
;; (use-package mood-line
;;   :hook (on-init-ui . mood-line-mode)
;;   :config
;;   (setq mood-line-glyph-alist mood-line-glyphs-fira-code)
;;   (setq-default header-line-format '("%e" (:eval (mood-line--process-format mood-line-format)))))
(use-package mini-echo
  :hook (doom-modeline-mode . mini-echo-mode)
  ;; :hook (mood-line-mode . mini-echo-mode)
  :config
  ;; Better cooler looking tabs (kind of)
  (setq tab-bar-new-button ""
	tab-bar-close-button-show nil
	tab-bar-back-button ""
	tab-bar-auto-width nil
	tab-bar-separator "    ")
  (set-face-attribute 'tab-bar nil :background "unspecified" :inherit 'default)
  (set-face-attribute 'tab-bar-tab-inactive nil :background "unspecified" :inherit 'font-lock-comment-face)
  (set-face-attribute 'tab-bar-tab nil :background "unspecified" :inherit 'default :box nil)
  (defun my/tab-bar-tab-name()
    (require 'project)
    (let ((buf (window-buffer (or (minibuffer-selected-window) (and (window-minibuffer-p) (get-mru-window))))))
      (with-current-buffer buf
	(let ((project (project-current)))
	  (or (and project (project-name project)) (buffer-name buf))))))
  (setq tab-bar-tab-name-function #'my/tab-bar-tab-name)
  ;; Switching tabs causes an echo-area msg, which also refreshes the tab-bar segment
  ;; So we don't really have to do anything special. Note that this is only a special
  ;; case due to the tab-switch behavior.
  (mini-echo-define-segment "tabs"
    "Display the list of tabs"
    :fetch (mini-echo-segment--print (mini-echo-segment--extract (tab-bar-format-tabs))))
  (defun my-detect() '(:both ("tabs")))
  (setq mini-echo-persistent-function 'my-detect
	;; Disable polling
	mini-echo-update-interval nil
	mini-echo-persistent-rule '(:both ("tabs"))
        mini-echo-temporary-rule nil))
(use-package evil-anzu)
(use-package anzu
  :after-call evil-ex-start-search evil-ex-start-word-search evil-ex-search-activate-highlight
  :config
  (global-anzu-mode +1)
  (require 'evil-anzu))
(use-package better-jumper
  :hook (on-first-input . better-jumper-mode)
  :init
  (global-set-key [remap evil-jump-forward]  #'better-jumper-jump-forward)
  (global-set-key [remap evil-jump-backward] #'better-jumper-jump-backward))
;; TODO: enable this someday
;; (use-package evil-textobj-tree-sitter
;;   :after evil
;;   :init
;;   (define-key evil-outer-text-objects-map "F" (evil-textobj-tree-sitter-get-textobj "function.outer"))
;;   (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner")))
;; :hook (on-first-input . (lambda ()
;; 			    (define-key evil-outer-text-objects-map "F" (evil-textobj-tree-sitter-get-textobj "function.outer"))
;; 			    (define-key evil-inner-text-objects-map "f" (evil-textobj-tree-sitter-get-textobj "function.inner"))))
;;;; Editor
;;
;; Important packages for editing, this is the usual "modern" stack:
;;   consult: provides lots of goodies for searching and jumping
;;   consult-dir: provides dir completion for consult
;;   vertico: verical completion buffer in the mini-buffer
;;   marginalia: provides annotation (tiny bits of information) on the sides for vertico
;;   corfu, nerd-icons-corfu: completion
;;   cape: completion extensions for corfu
;;   embark: basically a context menu activated using keybindings (supercharged which-key?)
;;   embark-consult: embark integration with consult
;;   orderless: searching by using matched components separated by space in any order (TODO: orderless-flex?)
;;   avy: jumping around (like vim-sneak, vim-easymotion, and co.)
;;   wgrep: slick search and replace
;;   vundo: visual undo
;;   dumb-jump: a smart dumb-jump
;;   dtrt-indent: guess the indentation so I don't have to
;;   treesit-fold: treesitter powered folding!
;;   popper: calm pop ups into patient hop ups
;; Editing is a hard job
(use-package consult
  :general
  (leader-keys
    "RET" '("bookmark" . consult-bookmark)
    "/" '("search" . consult-line)
    "g" '("grep" . consult-ripgrep)
    "j" '("jump" . consult-imenu)
    "hh" '("help help" . consult-info)
    "b" '("buffer" . consult-buffer)))
(use-package consult-dir
  :general
  (general-def 'vertic-map
    ("C-x C-d" . consult-dir)
    ("C-x C-j" . consult-dir-jump-file)))
(use-package vertico
  :hook (on-first-input . vertico-mode)
  :config
  (setq vertico-count 15
	vertico-resize nil)
  (general-def 'vertico-map
    "C-M-n" #'vertico-next-group
    "C-M-p" #'vertico-previous-group))
(use-package marginalia :hook (on-first-input . marginalia-mode))
(use-package embark
  :general
  (general-def minibuffer-local-map
    "C-;"      #'embark-act
    "C-c C-;"  #'embark-export
    "C-c C-l"  #'embark-collect)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
	       '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
		 nil
		 (window-parameters (mode-line-format . none)))))
(use-package embark-consult :hook (embark-collect-mode . consult-preview-at-point-mode))
(use-package orderless
  :after-call on-first-input-hook
  :config
  (setq completion-styles '(orderless basic))
  (setq completion-category-overrides '((file (styles partial-completion))))
  (setq completion-pcm-leading-wildcard t))
(use-package corfu
  :hook ((on-first-input . global-corfu-mode)
	 (corfu-mode . corfu-popupinfo-mode)
	 (corfu-mode . completion-preview-mode)
	 (corfu-mode . corfu-history-mode))
  :config
  (setq corfu-cycle t                   ;; Enable cycling
	corfu-auto nil                  ;; Don't autoshow popup
	corfu-auto-prefix 2             ;; Type at least two letters to enable autocompletion
	completion-cycle-threshold nil  ;; Show all matches
	corfu-auto-delay 0.25           ;; Delay until autocomplete starts
	corfu-preselect 'prompt
	corfu-preview-current 'insert)
  (setq completion-preview-sort-function corfu-sort-function))
(use-package nerd-icons-corfu
  :after-call global-corfu-mode
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
(use-package cape
  :hook (((prog-mode text-mode conf-mode commint-mode eshell-mode sh-mode bash-ts-mode) . set-default-capf)
	 (TeX-mode . set-tex-capf))
  :init
  (defun set-default-capf()
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev))
  (defun set-tex-capf()
    ;; (add-to-list 'completion-at-point-functions #'cape-tex)
    (add-to-list 'completion-at-point-functions #'cape-file)
    (add-to-list 'completion-at-point-functions #'cape-dabbrev)))
(use-package avy
  :after evil
  :general
  ;; TODO: check out if `avy-goto-char-timer` is better, it is more flexible
  (leader-keys "s" '("search (avy)" . avy-goto-char-2))
  :config
  (setq avy-background t))
(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config
  (setq wgrep-auto-save-buffer t))
(use-package vundo :commands (vundo))
(use-package dumb-jump
  :init
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  :general
  (general-def 'normal 'override
    "gd" #'xref-find-definitions)
    ;; "gr" #'xref-find-references)
  :config
  (setq dumb-jump-prefer-searcher 'rg
	xref-show-definitions-function #'consult-xref)
  (add-hook 'dumb-jump-after-jump-hook #'better-jumper-set-jump))
(use-package dtrt-indent
  :hook (on-first-buffer . dtrt-indent-global-mode)
  :config
  (setq dtrt-indent-max-lines 2000))
(use-package treesit-fold
  ;; :hook (on-first-file . global-treesit-fold-indicators-mode)
  :hook (on-first-file . global-treesit-fold-mode)
  :vc (:url "https://github.com/emacs-tree-sitter/treesit-fold.git" :rev :newest)
  :config
  (set-face-attribute 'treesit-fold-fringe-face nil :inherit 'font-lock-comment-face)
  (with-eval-after-load 'treesit-fold-indicators
    ;; (setq treesit-fold-indicators-priority -10)
    (define-fringe-bitmap 'treesit-fold-indicators-fr-center (vector #b00011000) 1 8 '(top t))
    (define-fringe-bitmap 'treesit-fold-indicators-fr-end-left (vector #b00011000) 1 8 '(top t))
    (define-fringe-bitmap 'treesit-fold-indicators-fr-plus
      (vector #b00110000
	      #b00011000
	      #b00001100
	      #b00000110
	      #b00001100
	      #b00011000
	      #b00110000))
    (define-fringe-bitmap 'treesit-fold-indicators-fr-minus-tail
      (vector #b00000000
	      #b00000000
	      #b11000011
	      #b01100110
	      #b00111100
	      #b00011000
	      #b00000000))))
(use-package popper
  :hook (on-first-buffer . popper-mode)
  :config
  (leader-keys
    "op" '("Open Popup (popper)" . popper-toggle)
    "cp" '("Create Popup (popper)" . popper-toggle-type))
  ;; Evil has it mapped to paste above and below, which is not particularly
  ;; useful, so we map it to cycle popups insteald
  (general-def 'normal 'override
    "]p" #'popper-cycle
    "[p" #'popper-cycle-backwards)
  (setq popper-reference-buffers
	'("\\*Messages\\*"
	  "Output\\*$"
	  "\\*Async Shell Command\\*"
	  "\\*eat\\*" ; Make the global eat terminal a popup
	  help-mode
	  compilation-mode)))
;;;; Development
;;
;; Actually using Emacs for coding. Proposterous, I know.
;;   magit: you shall not push
;;   diff-hl: vc signs in your gutters (fringees and guts)
;;   dirvish: sidebar, but also super ranger file manager for emacs
;;   dired-fl: color dired font locks
;;   eat: delicious terminal emulation
;;   docker: containerized development
;;   tempel: snippets and templates
(use-package magit
  :defer-incrementally
  dash f s with-editor git-commit package eieio transient
  :general
  (leader-keys
    "mm" '("magit status" . magit-status)
    "ml" '("magit log" . magit-log-current)
    "ma" '("magit annotate" . vc-annotate)
    "md" '("magit diff" . magit-diff-buffer-file))
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
(use-package diff-hl
  :hook (on-first-file . global-diff-hl-mode)
  :config
  ;; Already started on-first-file so no need to load on keybinds
  (general-def 'normal
    "gh" #'diff-hl-stage-current-hunk
    "gH" #'diff-hl-revert-hunk
    "]h" #'diff-hl-next-hunk
    "[h" #'diff-hl-previous-hunk)
  ;; Move fringes outside of margin and set margin to 1, since I am not using
  ;; line numbers I have to manually add this to create some room between the
  ;; fringe and the text.
  (setq-default fringes-outside-margins t
		left-margin-width '1)
  ;; Slightly simpler implementation of Doom's vc-gutter
  ;; Create a bit map for the fringe, where the left half is a solid bar. This
  ;; creates the bits 11110000 if width is eight or 1100 if width is four.
  ;; Fairly simple implementation, alternative can be factorial and left shift.
  (let* ((width 8)
	 (bitmap (vector (string-to-number (concat
					    (make-string (/ width 2) ?1)
					    (make-string (/ width 2) ?0)) 2))))
    ;; We use periodic '(top t) to repeat the bits instead of doing it manually
    (define-fringe-bitmap 'diff-hl-pretty-line bitmap 1 width '(top t)))
  ;; Creates a small triangle pointing to the right, used for deleted lines
  (let* ((width 8)
	 (bitmap (vector
		 #b11000000
		 #b11100000
		 #b11110000
		 #b11111000
		 #b11111100
		 #b11111000
		 #b11110000
		 #b11100000
		 #b11000000)))
    (define-fringe-bitmap 'diff-hl-pretty-delete bitmap 9 width))
  ;; Set our custom gutters
  (defun vc-gutter (type _pos)
    (if (eq type 'delete) #'diff-hl-pretty-delete #'diff-hl-pretty-line))
  (setq diff-hl-fringe-bmp-function #'vc-gutter)
  ;; Use fringes, I am not sure why 
  (diff-hl-margin-mode -1)
  ;; Nice defaults
  (setq diff-hl-side 'left
	diff-hl-global-modes '(not image-mode pdf-view-mode)
	;; Nicer and faster diffs
	vc-git-diff-switches '("--histogram")
	;; Don't block while updating
	diff-hl-update-async t
	;; updating diffs while staging and unstaging hunks
	diff-hl-show-staged-changes nil))
(use-package dirvish
  :general
  (leader-keys "os" '("open sidebar" . dirvish-side))
  (leader-keys "of" '("open file manager" . dirvish))
  :general-config
  ;; Keybinds, most are from Doom
  (general-def 'normal 'dirvish-mode-map
    "?"   #'dirvish-dispatch
    "h"   #'dired-up-directory
    "l"   #'dired-find-file
    "q"   #'dirvish-quit
    "<tab>" #'dirvish-subtree-toggle
    "<backtab>" #'dirvish-subtree-up
    "S"   #'dirvish-quicksort
    "F"   #'dirvish-layout-toggle
    "z"   #'dirvish-history-jump
    "p"   #'dirvish-yank)
  (general-def 'normal 'dirvish-mode-map :prefix "y"
    "l"   #'dirvish-copy-file-true-path
    "n"   #'dirvish-copy-file-name
    "p"   #'dirvish-copy-file-path
    "r"   #'dirvish-copy-remote-path
    "y"   #'dired-do-copy)
  :config
  (dirvish-override-dired-mode)
  (setq dirvish-reuse-session 'open
        dirvish-subtree-always-show-state t
	dirvish-use-header-line 'global
	dirvish-use-mode-line nil
        dirvish-side-width 27)
  ;; kanagawa (upstream ?) 
  (set-face-attribute 'dirvish-inactive nil :inherit 'mode-line-inactive)
  (set-face-attribute 'dirvish-hl-line nil :inherit 'hl-line)
  (set-face-attribute 'dirvish-hl-line-inactive nil :inherit 'hl-line)

  (defface dirvish-file-size '((t :inherit 'font-lock-comment-face)) "Dirvish")
  (defface dirvish-subtree-guide '((t :inherit 'font-lock-comment-face)) "Dirvish")
  (defface dirvish-subtree-state '((t :inherit 'font-lock-comment-face)) "Dirvish")

  ;; prettier
  (setq dirvish-nerd-icons-height 0.8
        dirvish-subtree-prefix "  ")
  (setq dirvish-hide-details '(dirvish dirvish-side)
	dirvish-hide-cursor '(dirvish dirvish-side))
  (setq dirvish-subtree-state-style 'nerd)
  (setq dirvish-attributes '(file-size nerd-icons subtree-state vc-state))
  ;; Not sure why but -11 gives perfect height
  (when-let (height (- (bound-and-true-p doom-modeline-height) 11))
    (setq dirvish-header-line-height height))
  ;; (setq dirvish-header-line-height 21)
  ;; Allow focusing the side normally
  (setq dirvish-side-window-parameters
	'((no-other-window . nil)
	  (no-delete-other-windows . t))))
(use-package diredfl
  :hook (dired-mode . diredfl-mode)
  :hook (dirvish-directory-view-mode . diredfl-mode))
(use-package eat
  :general
  (leader-keys
    "ot" '("open terminal" . eat)
    "pt" '("project terminal" . eat-project))
  :config
  ;; Restore <tab> autocompletion for eat
  (general-def 'insert 'eat-mode-map
   "<tab>" #'eat-self-input
   "<backtab>" #'eat-self-input))
(use-package docker
    :commands docker
    :config
    (setq docker-command "podman"
	  docker-compose-command "podman-compose"
	  docker-container-tramp-method "podman"))
(use-package tempel
  :commands (tempel-expand tempel-insert tempel-complete)
  :config
  ;; Sets up a repeat custom element for use in snippets, taken from the example
  ;; on tempel's repository. This is great for matrices and tables.
  (defun tempel-repeat (elt fields)
    (pcase elt
      (`(* ,count . ,rest)
       (cons 'l (cl-loop for i below (eval count fields) append rest)))))
  (add-to-list 'tempel-user-elements #'tempel-repeat)
  ;; Integrate snippets with completion
  (defun tempel-setup-capf ()
    (setq-local completion-at-point-functions
		(cons #'tempel-expand completion-at-point-functions)))
  (add-hook 'prog-mode-hook 'tempel-setup-capf)
  (add-hook 'text-mode-hook 'tempel-setup-capf))

;;;; Languages
;;
;; Coding languages, not actual languages (unfortunate). Powered by treesitter
;; as much as possible, which provides highlighting, indentation, and
;; combobulations. This is separted into three main categories: coding, org, and
;; latex.
;;   treesit: builtin sitter of trees
;;   c-ts-mode: sets linux style indentation and sibling files (I hate C)
;;   markdown-mode: marker time
;;   rust-mode: for a happy crustacean (TODO: restic-mode?)
;;   nix-mode: it is snowing! (TODO: nix-ts-mode)
;;   terraform-mode: terraforming the world (well it is opening tofus for me)
;;   qml-mode: for occasionally qt design
;;   code-cells: jupyter shenaningans, requires jupytext (https://github.com/astoff/code-cells.el)
;;   beancount: counting beans
;;   org-mode: magical unicorn
;;   org-roam: progenitor of all madness
;;   org-roam-ui, websocket: the main point of org-roam :)
;;   org-chef: unicorn fried rice, you are saying an unicorn fried this rice?
;;   evil-org-roam: evil unicorn
;;   auctex: the golden standard of TeX editing (needs latexmk)
;;   aas, laas: super fast autosnippets for latex and other stuff
;;   pdf-tools: pdf-viewer of choice
;;   auctex-cont-latexmk: automagically compile tex files via `auctex-cont-latexmk-mode'
;;   evil-tex: evil integration for LaTeX (like vimtex)
;; Yeah, these are kind of a mixed batch, maybe evil-org-roam should be in the
;; Evil section instead, but it kind of just roamed here. As usual, LaTeX setup
;; is inspired by 'https://castel.dev/' and 'https://karthinks.com/software/latex-input-for-impatient-scholars/'
(use-package treesit
  :ensure nil
  :mode
  (("\\.css\\'"    . css-ts-mode)
   ("\\.lua\\'"    . lua-ts-mode)
   ("\\.html\\'"   . html-ts-mode)
   ("\\.toml\\'"   . toml-ts-mode)
   ("\\.java\\'"   . java-ts-mode)
   ("\\.json5?\\'" . json-ts-mode)
   ("\\.ya?ml\\'"  . yaml-ts-mode)
   ("\\.py\\'"     . python-ts-mode)
   ("\\.c\\'"      . c-ts-mode)
   ("\\.h\\'"      . c-or-c++-ts-mode)
   ("\\.cpp\\'"    . c++-ts-mode)
   ("\\.cs\\'"     . c-sharp-ts-mode)
   ("\\.js\\'"     . js-ts-mode)
   ("\\([tj]sx\\)\\'" . tsx-ts-mode)
   ;; I am not sure how to make this all merged... probably some regex
   ("\\.cmake\\'" . cmake-ts-mode)
   ("\\CMakeLists.txt\\'" . cmake-ts-mode)
   ("\\Dockerfile\\'" . dockerfile-ts-mode)
   ("\\Containerfile\\'" . dockerfile-ts-mode))
  :interpreter ("bash" . bash-ts-mode)
  :preface
  ;; Sets font lock for more colorful code and add default recipes for
  ;; installing grammar.
  ;; TODO: treesit-auto? Honestly wish that was builtin...
  ;; TODO: pin releases
  (setq treesit-font-lock-level 4
	treesit-language-source-alist
	'((c "https://github.com/tree-sitter/tree-sitter-c.git")
	  (cpp "https://github.com/tree-sitter/tree-sitter-cpp.git")
	  (javascript "https://github.com/tree-sitter/tree-sitter-javascript.git")
	  (json "https://github.com/tree-sitter/tree-sitter-json.git")
	  (css "https://github.com/tree-sitter/tree-sitter-css.git")
	  (html "https://github.com/tree-sitter/tree-sitter-html.git")
	  (dockerfile "https://github.com/camdencheek/tree-sitter-dockerfile.git")
	  (cmake "https://github.com/uyha/tree-sitter-cmake.git")
	  (rust "https://github.com/tree-sitter/tree-sitter-rust.git")
	  (python "https://github.com/tree-sitter/tree-sitter-python.git")
	  (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "tsx/src"))
	  (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" "v0.20.3" "typescript/src"))
	  (bash "https://github.com/tree-sitter/tree-sitter-bash.git")
	  (lua "https://github.com/MunifTanjim/tree-sitter-lua.git")
	  (java "https://github.com/tree-sitter/tree-sitter-java.git")
	  (toml "https://github.com/ikatyang/tree-sitter-toml.git")
	  (csharp "https://github.com/tree-sitter/tree-sitter-c-sharp.get")
	  (yaml "https://github.com/ikatyang/tree-sitter-yaml.git")))
  ;; Do some remaps for built-in modes
  (dolist (mapping
	   '((python-mode . python-ts-mode)
	     (css-mode . css-ts-mode)
	     (yaml-mode . yaml-ts-mode)
	     (typescript-mode . typescript-ts-mode)
	     (js-mode . js-ts-mode)
	     (bash-mode . bash-ts-mode)
	     (conf-toml-mode . toml-ts-mode)
	     (json-mode . json-ts-mode)
	     (typescript-mode . typescript-ts-mode)
	     (js-json-mode . json-ts-mode)
	     (c-mode . c-ts-mode)
	     (c++-mode . c++-ts-mode)
	     (c-or-c++-mode . c-or-c++-ts-mode)))
    (add-to-list 'major-mode-remap-alist mapping)))
(use-package c-ts-mode
  :ensure nil
  :config
  (add-to-list 'find-sibling-rules '("/\\([^/]+\\)\\.c\\(c\\|pp\\)?\\'" "\\1.h\\(h\\|pp\\)?\\'"))
  (add-to-list 'find-sibling-rules '("/\\([^/]+\\)\\.h\\(h\\|pp\\)?\\'" "\\1.c\\(c\\|pp\\)?\\'"))
  (setq c-default-style "linux"
        c-ts-mode-indent-style 'linux
	c-ts-mode-indent-offset 8)
  (setq gdb-many-windows t
	gdb-use-separate-io-buffer t
	gdb-default-window-configuration-file (file-name-concat user-emacs-directory "gdbwinconf"))
  (defun my-stm32cubemx ()
    (interactive)
    (start-process "stm32cubemx " nil "stm32cubemx"))
  (defun my-find-header ()
    (interactive)
    (consult-fd nil (concat (file-name-base buffer-file-name) ".h")))
  (localleader-keys 'c-ts-mode-map
    "e" '("embedded (open stm32cubemx)" . my-stm32cubemx)
    "d" '("debugger" . gdb)
    "o" '("other file" . find-sibling-file)
    "h" '("other header" . my-find-header))
  ;; HACK: for some reason ts indent is broken in c, apparantly fixed in emacs 31
  ;; this breaks indentation style a little, but it should suffice for now
  (general-def 'insert 'c-ts-mode-map
    "RET" 'evil-ret-and-indent))
(use-package markdown-mode
  :mode "\\.md\\'"
  :hook (markdown-mode . visual-line-mode)
  :config
  (setq markdown-make-gfm-checkboxes-buttons t
        markdown-fontify-whole-heading-line t
        markdown-fontify-code-blocks-natively t
	markdown-enable-math t
	markdown-open-command "xdg-open"
	markdown-mouse-follow-link nil))
(use-package rust-mode
  :mode "\\.rs\\'"
  :config
  (setq rust-mode-treesitter-derive t))
(use-package nix-mode :mode "\\.nix\\'")
(use-package terraform-mode
  :mode "\\.tf\\'"
  :config
  (setq terraform-command "tofu"
	terraform-format-on-save t))
(use-package qml-mode :mode "\\.qml\\'")
(use-package svelte-mode :mode "\\.svelte\\'")
(use-package code-cells :mode ("\\.ipynb\\'" . code-cells-mode))
(use-package beancount
  :mode ("\\.bean\\'" . beancount-mode)
  :hook ((beancount-mode . outline-minor-mode)
	 (beancount-mode . flymake-bean-check-enable)))
(use-package org
  :ensure nil
  :defer-incrementally
  calendar find-func format-spec org-macs org-compat org-faces org-entities
  org-list org-pcomplete org-src org-footnote org-macro ob org org-agenda
  org-capture ox
  :hook (org-mode . visual-line-mode)
  :general
  (leader-keys
    "na" '("org agenda" . org-agenda)
    "nn" '("org capture" . org-capture)
    "nj" '("org jump agenda" . consult-org-agenda)
    "nc" '("org clock last" . org-clock-in-last)
    "nC" '("org clock out" . org-clock-out)
    "nt" '("org current clock task" . org-clock-goto))
  :preface
  ;; Reduces first load delay, I don't think I need any of these actually,
  ;; well maybe bibtex in the future
  (defvar org-modules
    '(;; ol-w3m
      ;; ol-bbdb
      ol-bibtex
      ;; ol-docview
      ;; ol-gnus
      ;; ol-info
      ;; ol-irc
      ;; ol-mhe
      ;; ol-rmail
      ;; ol-eww
      ))
  :init
  (defun org-init ()
    ;; Set some nice settings
    (setq org-clock-clocked-in-display 'frame-title
	  org-clock-in-switch-to-state "NEXT"
	  org-clock-idle-time 30)
    (setq org-startup-indented t
	  ;; put tags after the heading, complements with no tag alignment
	  ;; this is for performance in large org files
	  org-auto-align-tags nil
	  org-tags-column 0
	  ;; don't show inbox or calfeed tag, not really important
	  org-agenda-hide-tags-regexp "inbox\\|calfeed"
	  ;; catch and show errors
	  org-catch-invisible-edits 'show-and-error
	  org-insert-heading-respect-content t
	  ;; prettify
	  org-hide-emphasis-markers t
	  org-pretty-entities t
	  ;; show diary entries (birthdays, anniversities) in agenda
	  org-agenda-include-diary t)
    ;; Create some org files,
    ;;   inbox.org is where captured notes go
    ;;   todo.org is where notes from inbox.org gets filed to
    ;;   agenda.org is where reoccuring tasks or tasks with a time interval go
    ;; So captured -> inbox.org -> todo.org
    (setq org-directory "~/org/"
          org-agenda-files '("agenda.org" "inbox.org" "todo.org" "calfeed.org")
	  org-stuck-projects '("+COOKIE_DATA=\"todo recursive\"/-DONE" ("NEXT") nil "")
	  org-clock-persist 'history)
    ;; Refiling
    ;; Everything expect for meetings gets forwarded to my inbox where I refile
    ;; them later, usually at the end of the day
    (setq org-capture-templates
	  `(("t" "todo" entry (file "inbox.org")
	     "* TODO %?\n%U")
	    ("q" "quick" entry (file "inbox.org")
	     "* NEXT %?\n%U")
	    ("n" "note" entry (file "inbox.org")
	     "* %? :note:\n%U")
	    ("m" "meeting" entry (file+headline "agenda.org" "Future")
	     "* MEETING: %?\nSCHEDULED: <%<%Y-%m-%d %H:00>>")
	    ("c" "cookbook" entry (file "~/org/cookbook.org")
	     "%(org-chef-get-recipe-from-url)"
	     :empty-lines 1)
	    ("z" "protocol cookbook" entry (file "~/org/cookbook.org")
	     "%(org-chef-get-recipe-string-from-url \"%:link\")"
	     :empty-lines 1)
	    ("m" "manual cookbook" entry (file "~/org/cookbook.org")
	     "* %^{Recipe title: }\n  :PROPERTIES:\n  :source-url:\n  :servings:\n  :prep-time:\n  :cook-time:\n  :ready-in:\n  :END:\n** Ingredients\n   %?\n** Directions\n\n")))
    ;; Tags
    ;;   Reading is for books or articles
    ;;   Resource is for something I need to continuously refer back to
    ;;   Tuning is QoL for me
    ;;   Note is for notes, like tid bits of cool information
    ;;   Hobby is well, hobbies
    ;;   Code is something code related
    ;;   Aerospace is something aerospace related
    ;;   Flagged is something which I need to get done quick
    (setq org-tag-alist (quote (("reading" . ?r)
				("resource" . ?R)
				("tuning" . ?t)
				("note" . ?t)
				("hobby" . ?h)
				("code" . ?c)
				("aerospace" . ?a)
				("FLAGGED" . ?f))))
    ;; Refiling
    (setq org-refile-targets '(("todo.org" :maxlevel . 3)))
    (setq org-refile-use-outline-path 'file)
    (setq org-outline-path-complete-in-steps nil)
    ;; Todo state
    (setq org-todo-keywords
	  '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
	    (sequence "HOLD(h)" "|" "CANCELLED(c)")))
    ;; Agenda customizations
    ;; Remove separator horizontal lines
    (setq org-agenda-block-separator nil)
    ;; Log DONE tags with :CLOSED [time]
    (setq org-log-done 'time)
    ;; Custom version of `n' where NEXT, TODO, and DONE are separated
    (setq org-agenda-custom-commands
	  '(("n" "main agenda"
	     ((agenda ""
		      ((org-agenda-span 'day)
		       (org-deadline-warning-days 14)
		       (org-deadline-past-days 1)
		       (org-agenda-time-grid '((daily) (800 1000 1200 1400 1600 1800 2000) "......" "---------------"))
		       (org-agenda-current-time-string "--- < now > ---")))
	      (tags "inbox"
		    ((org-agenda-prefix-format " %i %-12:c%?-12t% s")
		     (org-agenda-overriding-header "\nInbox (You should refile these, like right now):")))
	      (stuck ""
		    ((org-agenda-prefix-format " %i %-12:c%?-12t% s")
		     (org-agenda-overriding-header "Stuck Projects (Get these moving by assigning a task NEXT):")))
	      (todo "NEXT"
		    ((org-agenda-prefix-format " %i %-11:c[%e] ")
		     (org-agenda-overriding-header "Next (Do these when you have time):")))
	      (tags-todo "-inbox/!-HOLD-NEXT"
		    ((org-agenda-prefix-format " %i %-12:c%?-12t% s")
		     ;; Skip project tasks
		     (org-agenda-skip-function '(org-agenda-skip-subtree-if 'regexp "\[[0-9]+\/[0-9]+\]"))
		     (org-agenda-overriding-header "Todo (Do these when you are being a lazy bum):")))
	      (todo "HOLD"
		    ((org-agenda-prefix-format " %i %-12:c%?-12t% s")
		     ;; Skip project tasks
		     (org-agenda-skip-function '(org-agenda-skip-subtree-if 'regexp "\[[0-9]+\/[0-9]+\]"))
		     (org-agenda-overriding-header "\nHold (Check on these occasionally):"))))))))
  (add-hook 'org-load-hook #'org-init)
  :config
  (org-clock-persistence-insinuate)
  ;; Auto save after refiling
  (advice-add 'org-refile :after
        (lambda (&rest _)
          (org-save-all-org-buffers)))
  (general-def 'normal 'org-mode-map "RET" #'org-open-at-point)
  ;; I define projects as just simply having multiple tasks. That is it. To help
  ;; org identify projects, we a insert COOKIE_DATA property.
  (defun make-org-project()
    (interactive)
    (when (not (string-match "\\[[0-9]*/[0-9]*\\]" (thing-at-point 'line t)))
      (org-set-property "COOKIE_DATA" "todo recursive")
      (save-excursion
	(end-of-line)
	(insert " [/]")
	(org-update-statistics-cookies nil))))
  (defun my-org-yank-dir() (concat (filename-name-sans-extension (buffer-file-name) "images")))
  ;; (setq org-yank-image-save-method #'my-org-yank-dir)
  (localleader-keys 'org-mode-map
    "u" '("org upload" . yank-media)
    "s" '("org state" . org-todo)
    "j" '("org jump heading" . consult-org-heading)
    "r" '("org refile" . org-refile)
    "t" '("org tag" . org-set-tags-command)
    "e" '("org effort" . org-set-effort)
    "p" '("org make project" . make-org-project)
    "c" '("org clock" . org-clock-in)))
(use-package org-roam
  :general
  (leader-keys "nm" '("notes mind" . org-roam-node-find))
  :general-config
  ;; make sure these do not conflict with the ones above
  (localleader-keys 'org-mode-map
    "f" '("roam find" . org-roam-node-find)
    "F" '("roam find ref" . org-roam-ref-find)
    "i" '("roam insert" . org-roam-node-insert)
    "I" '("roam id create" . org-id-get-create)
    "b" '("roam backlinks" . org-roam-buffer-toggle)
    "R" '("roam refile" . org-roam-refile))
  :config
  ;; From https://jmthornton.net/blog/p/org-roam-created-modified-dates
  ;; Adds created and modified to properties automatically. Using this instead of org-roam-timestamps
  ;; because that one does it for all nodes which is too much for me, I just need it for files
  (defun org-roam-extract-timestamp-from-filepath (filepath)
    "Extract timestamp from the Org-roam FILEPATH assuming it follows the default naming scheme."
    (let ((filename (file-name-nondirectory filepath)))
      (when (string-match "\\([0-9]\\{12\\}\\)" filename) (match-string 1 filename))))

  ;; These insert :date and :updated into properties automatically
  (defun org-roam-insert-created-property ()
    (interactive)
    (when (org-roam-file-p)
      ;; Don't update if the created property already exists
      (unless (org-entry-get (point-min) "date" t)
	(let ((creation-time (org-roam-extract-timestamp-from-filepath
                              (buffer-file-name))))
          ;; Don't error if the filename doesn't contain a timestamp
          (when creation-time
            (save-excursion
              ;; Ensure point is at the beginning of the buffer
              (goto-char (point-min))
              (org-set-property "date" creation-time)))))))

  (defun org-roam-insert-modified-property ()
    (when (org-roam-file-p)
      (save-excursion
	;; Ensure property is applied to the whole file
	(goto-char (point-min))
	(org-set-property
	 "updated" (format-time-string "%Y%m%d%H%M")))))
  (add-hook 'before-save-hook #'org-roam-insert-created-property)
  (add-hook 'before-save-hook #'org-roam-insert-modified-property)
  
  (setq org-roam-directory "~/org/roam"
	rg-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; https://zettelkasten.de/posts/concepts-sohnke-ahrens-explained/
  ;; default is going to be the main notes I have, these are the Permanent Notes
  ;; fleeting is when I am quickly capturing something down and need to refine later
  ;;   and is equivalent to Fleeting Notes (I am more likely to jot them in my notebook though)
  ;; literature is for capturing references temporarily and then moving it to something like zotero
  ;;   this is the equivalent to Literature Notes
  ;; index is structural notes, kind of like a ToC or MoC and serves as a hub for notes
  ;; Project Notes I do not really have a need, but is probably best served with a physical notebook 
  ;;
  ;; Hubs serves as "topic tags" essentially. I can thus reserve tags for describing the note
  ;; itself (tags as topics gets too large and messy). For example, I have the usual
  ;;    fleeting, literature, index
  ;; which is the the type of note itself, but I also have
  ;;    question, theory, implementation, definition
  ;; for how the note is used
  ;; TODO: maybe use observation, assumption, code, reference?
  (setq org-roam-capture-templates
	'(("d" "default" plain "%?"
	   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	   :unnarrowed t)
	  ("f" "fleeting note" plain "%?"
	   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: fleeting")
	   :unnarrowed t)
	  ("l" "literature note" plain "%?"
	   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: literature")
	   :unnarrowed t)
	  ("i" "index note" plain "%?"
	   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n#+filetags: index")
	   :unnarrowed t))))
(use-package websocket :after org-roam)
(use-package org-roam-ui
  :after org-roam
  :commands (org-roam-ui-open)
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t
	org-roam-ui-open-on-start t))
(use-package org-chef)
(use-package evil-org
  :hook ((org-mode . evil-org-mode)
	 (org-agenda-mode . evil-org-mode))
  :config
  (evil-org-set-key-theme)
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))
(use-package auctex
  :mode ("\\.tex\\'" . latex-mode)
  :hook ((LaTeX-mode . auto-fill-mode)
	 (LaTeX-mode . prettify-symbols-mode))
  :config
  (setq TeX-parse-self t
	TeX-auto-save t
	;; Cleaner dir
	TeX-auto-local ".auctex-auto"
	TeX-style-local ".auctex-style"
	;; Better correlate behavior
	TeX-source-correlate-mode t
	TeX-source-correlate-method 'synctex
	TeX-source-correlate-start-server nil
	TeX-save-query nil
	;; I always use the same one so don't prompt
	TeX-master "main.tex"
	;; from Doom, better scaling for previews
	preview-scale 1.4
	preview-scale-function (lambda () (* (/ 10.0 (preview-document-pt)) preview-scale))
	;; Preview improvements
	preview-auto-cache-preamble nil
	preview-protect-point t
	preview-locating-previews-message nil
	preview-leave-open-previews-visible t
	;; Preview using DVIs, faster, but has some caveats (hyperref not working)
	preview-LaTeX-command-replacements '(preview-LaTeX-disable-pdfoutput)
	preview-image-type 'dvipng
	;; View using pdf tools
	TeX-view-program-selection '((output-pdf "PDF Tools")))
  (add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)
  ;; This huge function makes proper and really pleasing indentations for
  ;; item-like environments. This was taken from:
  ;; https://emacs.stackexchange.com/questions/3083/how-to-indent-items-in-latex-auctex-itemize-environments?noredirect=1
  (setq LaTeX-indent-level-item-continuation 8)
  (defun LaTeX-indent-item ()
    "Provide proper indentation for LaTeX \"itemize\",\"enumerate\", and
    \"description\" environments.

    \"\\item\" is indented `LaTeX-indent-level' spaces relative to
    the the beginning of the environment.

    Continuation lines are indented either twice
    `LaTeX-indent-level', or `LaTeX-indent-level-item-continuation'
    if the latter is bound."
    (save-match-data
      (let* ((offset LaTeX-indent-level)
	     (contin (or (and (boundp 'LaTeX-indent-level-item-continuation)
			      LaTeX-indent-level-item-continuation)
			 (* 2 LaTeX-indent-level)))
	     (re-beg "\\\\begin{")
	     (re-end "\\\\end{")
	     (re-env "\\(itemize\\|\\enumerate\\|description\\)")
	     (indent (save-excursion
		       (when (looking-at (concat re-beg re-env "}"))
			 (end-of-line))
		       (LaTeX-find-matching-begin)
		       (current-column))))
	(cond ((looking-at (concat re-beg re-env "}"))
	       (or (save-excursion
		     (beginning-of-line)
		     (ignore-errors
		       (LaTeX-find-matching-begin)
		       (+ (current-column)
			  (if (looking-at (concat re-beg re-env "}"))
			      contin
			    offset))))
		   indent))
	      ((looking-at (concat re-end re-env "}"))
	       indent)
	      ((looking-at "\\\\item")
	       (+ offset indent))
	      (t
	       (+ contin indent))))))
  (setq LaTeX-indent-environment-list
	(nconc '(("itemize" LaTeX-indent-item)
		 ("enumerate" LaTeX-indent-item)
	       LaTeX-indent-environment-list)))
  ;; From https://karthinks.com/software/latex-input-for-impatient-scholars/
  (defun latex-math-from-calc ()
    "Evaluate `calc' on the contents of line at point."
    (interactive)
    (cond ((region-active-p)
	   (let* ((beg (region-beginning))
		  (end (region-end))
		  (string (buffer-substring-no-properties beg end)))
	     (kill-region beg end)
	     (insert (calc-eval `(,string calc-language latex
					  calc-prefer-frac t
					  calc-angle-mode rad)))))
	  (t (let ((l (thing-at-point 'line)))
	       (end-of-line 1) (kill-line 0)
	       (insert (calc-eval `(,l
				    calc-language latex
				    calc-prefer-frac t
				    calc-angle-mode rad)))))))

  (defun inkfig ()
    (interactive)
    (start-process "inkfig " nil "inkfig" (format "%s/figures/%s.svg"
						  (buffer-local-value 'default-directory (current-buffer))
						  (symbol-at-point))))
  ;; Copies the latest screenshot to the images directory. Optionally makes the
  ;; image transparent (note that image has to have white background). This requires a specifc naming convention, 
  ;; images get copied as "filename-imagecount", so if the file name is 1.tex, and there are
  ;;   images/1-1.png, images/1-2.png
  ;; then this command will create the file images/1-3.png.
  (defun my-upload-image (transparent)
    (interactive)
    (let ((filename (shell-command-to-string
		     (format "echo images/%s-$(($(find images/%s-*.png 2>/dev/null | wc -l) + 1)).png"
			     (file-name-base)
			     (file-name-base))))
	  (shell-command-switch "-ic"))
      (call-process-shell-command (format "copy-screenshot %s &" filename) nil 0)
      (if transparent
	  (call-process-shell-command (format "magick-transparent %s &" filename) nil 0)
	nil)))
  (defun my-upload-image-transparent () (interactive) (my-upload-image t))
  (defun my-upload-image-nontransparent () (interactive) (my-upload-image nil))
  ;; Compile using latexmk
  (defun compile-latex ()
    (interactive)
    (TeX-save-document (TeX-master-file))
    (TeX-command "LaTeXMk" 'TeX-master-file -1))
  ;; Run my inkfig script using the symbol at point as the name  
  ;; Use start process to avoid creating a buffer
  (defun inkfig ()
    (interactive)
    (start-process "inkfig " nil "inkfig" (format "%s/figures/%s.svg"
						  (buffer-local-value 'default-directory (current-buffer))
						  (symbol-at-point))))
  (localleader-keys 'LaTeX-mode-map
    "e" '("latex evaluate" . latex-math-from-calc)
    "u" '("latex upload" . my-upload-image-transparent)
    "U" '("latex upload" . my-upload-image-nontransparent)
    "p" '("latex preview" . preview-at-point)
    "P" '("latex unPreview" . preview-clearout-at-point)
    "f" '("latex figures" . inkfig)
    "a" '("latex auto-compile" . auctex-cont-latexmk-toggle)
    "c" '("latex compile" . compile-latex)
    "v" '("latex view" . TeX-view)))
(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  ;; Follow theme
  (add-hook 'pdf-view-mode-hook 'pdf-view-themed-minor-mode)
  ;; Fixes flickering of cursor due to evil, and also gets rid of the 
  ;; pesky one pixel border frame on the pdf view as well
  ;; https://www.reddit.com/r/emacs/comments/dgywoo/issue_with_pdfview_midnight_mode/
  (defun pdf-tools-hide-evil-cursor ()
      (set (make-local-variable 'evil-normal-state-cursor) (list nil)))
  (add-hook 'pdf-view-mode-hook #'pdf-tools-hide-evil-cursor))
(use-package auctex-cont-latexmk
  :commands (auctex-cont-latexmk-toggle)
  :config
  ;; Runs compilation hooks when reporting errors, this sets it up with
  ;; revert-buf and refreshes the pdf viewer if I have it open
  ;; It is kind of hacky but works most of the time
  (define-advice auctex-cont-latexmk-send-report (:after nil revert-buf-after-report)
    (TeX-revert-document-buffer "main.pdf")))
(use-package aas
  :hook ((LaTeX-mode . aas-activate-for-major-mode)
	 (org-mode . aas-activate-for-major-mode)))
(use-package laas
  :hook ((LaTeX-mode . laas-mode)
	 (org-mode . laas-mode)
	 (markdown-mode . laas-mode))
  :config
  ;; Do not add space after auto expanding snippets, main use case is so I can
  ;; directly wrap the expanded term into a fraction if I wanted to without
  ;; backspacing first.
  (setq laas-enable-auto-space nil)
  ;; Taken from https://github.com/karthink/lazytab
  ;; Credits to karthink and their excellent post:
  ;; https://karthinks.com/software/latex-input-for-impatient-scholars/
  ;;
  ;; Basically allows one to make table environments using org tables,
  ;; then convert to latex tables via C-c C-c once done
  ;;
  ;; Main caveat is you can't turn it back into an org table.
  (defun my/orgtbl-replace (_)
    (interactive "P")
    (unless (org-at-table-p) (user-error "Not at a table"))
    (let* ((table (org-table-to-lisp))
	   (params '(:backend latex :raw t))
	   (replacement-table (orgtbl-to-latex table params)))
      (kill-region (org-table-begin) (org-table-end))
      (open-line 1)
      (push-mark)
      (insert replacement-table)
      (align-regexp (region-beginning) (region-end) "\\([:space:]*\\)& ")
      (indent-region (region-beginning) (region-end))
      (orgtbl-mode -1)
      (advice-remove 'orgtbl-ctrl-c-ctrl-c #'my/orgtbl-replace)))
  (defun my/latex-orgtb ()
    (require 'org-table)
    (advice-add 'orgtbl-ctrl-c-ctrl-c :after #'my/orgtbl-replace)
    (orgtbl-mode 1)
    (insert "|"))
  ;; Returns whether we are inside an qty macro or not
  (defun my/inside-qty ()
    (save-excursion
      ;; We move backward to the previous } since something like \qty{123}{\kg|}
      ;; will have a `TeX-current-macro' of nil
      (search-backward "}" (line-beginning-position) t)
      (string-equal (TeX-current-macro) "qty")))
  ;; From https://github.com/tecosaur/LaTeX-auto-activating-snippets/issues/25
  ;; Allows using laas in markdown math environments as well
  (defun laas-mathp ()
    "Determine whether point is within a LaTeX maths block."
    (cond
     ((derived-mode-p 'latex-mode) (texmathp))
     ((derived-mode-p 'markdown-mode) (texmathp))
     ((derived-mode-p 'org-mode) (laas-org-mathp))
     (t (message "LaTeX-auto-activated snippets does not currently support math in any of %s"
		 (aas--modes-to-activate major-mode))
	nil)))
  ;; checks if point is at beginning of indentation 
  (defun boip () (= (save-excursion (back-to-indentation) (point)) (point)))
  (aas-set-snippets 'laas-mode
    "mk"   '(tempel "$" p "$" q)
    "qty"  '(tempel "\\qty{" p "}" "{" p "}" q))
  ;; General snippets which should expand only on the beginning of the line
  (aas-set-snippets 'laas-mode
    :cond 'boip
    "dm"    '(tempel "\\[" n> q n "\\]" >)
    "beg"   '(tempel "\\begin{" (s env) "}" n> q n "\\end{" (s env) "}" >)
    "fig"   '(tempel "\\begin{figure}[htb]" n> "\\centering" n> "\\caption{" p "}" n> "\\incfig{" q "}" > n "\\end{figure}" >)
    "img"   '(tempel "\\begin{figure}[htb]" n> "\\centering" n> "\\caption{" p "}" n> "\\includegraphics[width=\\linewidth]{" q "}" > n "\\end{figure}" >)
    "mfig"  '(tempel "\\begin{marginfigure}" n> "\\centering" n> "\\caption{" p "}" n> "\\incfig{" q "}" > n "\\end{marginfigure}" >)
    "mnote" '(tempel "\\marginnote{" n> q n "}" >)
    "enum"  '(tempel "\\begin{enumerate}" n> "\\item " q > n "\\end{enumerate}" >)
    "item"  '(tempel "\\begin{itemize}" n> "\\item " q > n "\\end{itemize}" >)
    "tabl"  '(tempel "\\begin{table}[h]" n> "\\centering" n> q n "\\end{table}" > :post (my/latex-orgtb))
    "ali"   '(tempel "\\begin{align*}" n> q n "\\end{align*}" >)
    "mdframed" '(tempel "\\begin{mdframed}" n> q n "\\end{mdframed}" >)
    "theorem" '(tempel "\\begin{theorem}" n> q n "\\end{theorem}" >)
    "definition" '(tempel "\\begin{definition}[" (p (read-string "Definition: ")) "]" n> q n "\\end{definition}" >))
  ;; Snippets which expand inside qty (for units)
  ;; I am only going to put the most common ones with the most common abbreviations
  ;; (aas-set-snippets 'laas-mode
  ;;   :cond 'my/inside-qty
  ;;   ;; Prefixes
  ;;   "mega"    "\\mega"
  ;;   "kilo"    "\\kilo"
  ;;   "centi"   "\\centi"
  ;;   "milli"   "\\milli"
  ;;   "micro"   "\\micro"
  ;;   ;; "pico"    "\\pico"
  ;;   ;; Exponents
  ;;   "per"   "\\per"
  ;;   ;; "ss"     "\\square"
  ;;   ;; "cc"     "\\cubic"
  ;;   ;; Units
  ;;   "newton" "\\newton"
  ;;   "joule"  "\\joule"
  ;;   "watt"   "\\watt"
  ;;   "gram"   "\\gram"
  ;;   "liter"  "\\liter"
  ;;   "meter"  "\\meter"
  ;;   "pascal" "\\pascal"
  ;;   "second" "\\second"
  ;;   ;; non SI
  ;;   "lbf"   "\\lbf"
  ;;   "lb"    "\\lb"
  ;;   "slug"  "\\slug"
  ;;   "psi"   "\\psi"
  ;;   "feet"  "\\feet"
  ;;   ;; These have minimal conflicts and are used a lot so shorthands are justified
  ;;   "kg"  "\\kilo\\gram"
  ;;   "vel" "\\meter\\per\\second"
  ;;   "acc" "\\meter\\per\\square\\second")
  ;; Reset these snippets, we will override them later
  (aas-set-snippets 'laas-mode
    "RR" nil
    "QQ" nil
    "PP" nil)
  ;; Snippets which should expand in math mode only
  (aas-set-snippets 'laas-mode
    :cond 'texmathp 
    ;; Important snippets
    "dint" '(tempel "\\int" "_{" (p "0") "}^{" (p "x") "} " (p "f(x)")  "\\, " (p "dx"))
    "sum"  '(tempel "\\sum" "_{" (p "k = 0") "}^{" (p "\\infty") "} " q)
    "lim"  '(tempel "\\lim" "_{" (p "n \to \infty") "} " q)
    "part" '(tempel "\\frac{\\partial " (p "x") "}{\\partial " (p "y") "}")
    "ppart" '(tempel "\\frac{\\partial^2 " (p "x") "}{\\partial " (p "y") "^2}")
    "mcal" '(tempel "\\mathcal{" p "}" q)
    "tt"   '(tempel "\\text{" p "}" q)
    "case" '(tempel "\\begin{cases}" n> q n "\\end{cases}" >)
    ;; Matrices and vectors
    "cvec" '(tempel "\\begin{pmatrix} " (p "x") " \\\\ \\vdots \\\\ " (p "x_{n}") " \\end{pmatrix}" q)
    "pmat" '(tempel "\\begin{pmatrix}" n> q n "\\end{pmatrix}" >)
    "mat"  '(tempel (p (read-number "Rows: ") rows noinsert)
		   (p (read-number "Cols: ") cols noinsert)
		   "\\begin{pmatrix}" n
		   >
		   (* (1- rows) (p " ") (* (1- cols) " & " (p " ")) "\\\\" n)
		   (p " ") (* (1- cols) " & " (p " ")) n
		   "\\end{pmatrix}" >)
    ;; Operations
    "sq"     '(tempel "\\sqrt{" (p "x") "}" q)
    "ceil"   '(tempel "\\left\\lceil " (p "x") " \\right\\rceil" q)
    "floor"  '(tempel "\\left\\lfloor " (p "x") " \\right\\rfloor" q)
    "lapl"   "\\Lapl"
    ;; Subscripts and Superscripts
    "invs"   "^{-1}"
    "td"     '(tempel "^{" p "}" q)
    "_"      '(tempel "_{" p "}" q)
    ;; Relations
    "->"  "\\rightarrow"
    "<-"  "\\leftarrow"
    "cc"  "\\subset"
    "c="  "\\subseteq"
    "nn"  "\\cap"
    "uu"  "\\cup"
    ;; Symbols
    "oo"   "\\infty"
    "pi"   "\\pi"
    "phi"   "\\phi"
    "psi"   "\\psi"
    "epsilon" "\\epsilon"
    "nabla" "\\nabla"
    "lambda" "\\lambda"
    "theta" "\\theta"
    "OO"   "\\emptyset"
    "RR"   "\\R"
    "QQ"   "\\Q"
    "PP"   "\\P"
    ;; Delimiters
    "lrp" '(tempel "\\left( " p " \\right)" q)
    "lrb" '(tempel "\\left\\{ " p " \\right\\}" q)
    "lra" '(tempel "\\left\\langle " p " \\right\\rangle" q)
    "lrl" '(tempel "\\left| " p " \\right|" q)))
(use-package evil-tex
  :after evil
  :hook (LaTeX-mode . evil-tex-mode))

;;;; Utilities
;;
;; Utilities, like spellchecking and other stuff. These are general purpose
;; modules or just random cool gimmicks, no Tetris is not a gimmick by the way.
;;   jinx: much faster alternative to flyspell which spells the end for my buffers
;;   envrc: direnv (nix ball knowledge, well not really) integration
;;   calfw: emacs calendar, well a blocky alternative one
;;   calfw-org: add org events to calfw
;;   apheleia: for formatting
;;   flymake-shellcheck: flymake backend for 'sh-mode'
;;   dashboard: a dashboard opened once and never again
;;   elfeed: reading feeds in emacs, feeding reads in emacs
;;   olivetti: nice, sleepy margins for reading text-based stuff
;;   emacs-everywhere: its always with you, like a puppy dog
;;   restart-emacs: give emacs a little restart
;; TODO: (use-package calfw-blocks :vc (:url "https://github.com/ml729/calfw-blocks.git" :rev :newest))
(use-package jinx
  ;; I pull this in using nix and not package.el
  :ensure nil
  :hook ((text-mode . jinx-mode)
	 (TeX-mode . jinx-mode)
	 (markdown-mode . jinx-mode))
  :config
  (general-def 'insert "C-l" #'jinx-correct)
  (general-def 'normal
    "]s" #'jinx-next
    "[s" #'jinx-previous))
(use-package envrc :hook (on-first-file . envrc-global-mode))
(use-package calfw
  :commands calfw-open-calendar-buffer
  :config
  ;; TODO: Kind of finicky need better solution
  (evil-set-initial-state 'calfw-calendar-mode 'insert)
  (evil-set-initial-state 'calfw-details-mode 'insert)
  ;; Better, less jarring colors (temporary for now, copied from repo)
  (set-face-attribute 'calfw-title-face nil :foreground "#f0dfaf" :weight 'bold :height 2.0 :inherit 'variable-pitch)
  (set-face-attribute 'calfw-header-face nil :foreground "#d0bf8f" :weight 'bold)
  (set-face-attribute 'calfw-sunday-face nil :foreground "#cc9393" :background "grey10" :weight 'bold)
  (set-face-attribute 'calfw-saturday-face nil :foreground "#8cd0d3" :background "grey10" :weight 'bold)
  (set-face-attribute 'calfw-holiday-face nil :background "grey10" :foreground "#8c5353" :weight 'bold)
  (set-face-attribute 'calfw-grid-face nil :foreground "DarkGrey")
  (set-face-attribute 'calfw-default-content-face nil :foreground "#bfebbf")
  (set-face-attribute 'calfw-periods-face nil :foreground "cyan")
  (set-face-attribute 'calfw-day-title-face nil :background "grey10")
  (set-face-attribute 'calfw-default-day-face nil :weight 'bold :inherit 'calfw-face-day-title)
  (set-face-attribute 'calfw-annotation-face nil :foreground "RosyBrown" :inherit 'calfw-face-day-title)
  (set-face-attribute 'calfw-disable-face nil :foreground "DarkGray" :inherit 'calfw-face-day-title)
  (set-face-attribute 'calfw-today-title-face nil :background "#7f9f7f" :weight 'bold)
  (set-face-attribute 'calfw-today-face nil :background "grey10" :weight 'bold)
  (set-face-attribute 'calfw-toolbar-face nil :foreground "Steelblue4" :background "Steelblue4")
  (set-face-attribute 'calfw-toolbar-button-off-face nil :foreground "Gray10" :weight 'bold)
  (set-face-attribute 'calfw-toolbar-button-on-face nil :foreground "Gray50" :weight 'bold)

  (general-def 'calfw-calendar-mode-map
    "h"   #'calfw-navi-previous-day-command
    "j"   #'calfw-navi-next-week-command
    "k"   #'calfw-navi-previous-week-command
    "l"   #'calfw-navi-next-day-command
    "RET" #'calfw-show-details-command
    "D"   #'calfw-change-view-day
    "M"   #'calfw-change-view-month
    "T"   #'calfw-change-view-two-weeks
    "W"   #'calfw-change-view-week)
  (general-def 'calfw-details-mode-map
    "q"   #'calfw-details-kill-buffer-command))
(use-package calfw-org
  :commands (calfw-org-open-calendar
             calfw-org-create-source
             calfw-org-create-file-source
             calfw-open-org-calendar-withkevin))
(use-package calfw-org :commands cfw:open-org-calendar)
(use-package apheleia)
(use-package flymake-shellcheck
  :hook (((sh-mode bash-ts-mode). flymake-shellcheck-load)
	 ((sh-mode bash-ts-mode). flymake-mode))
  :commands flymake-shellcheck-load)
(use-package dashboard
  :demand t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner 3)
  (setq dashboard-items '((recents . 5)))
  (setq dashboard-banner-logo-title "D E S P A I R")
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-show-shortcuts nil)
  (setq dashboard-set-footer nil))
(use-package elfeed
  :commands elfeed
  :general
  (leader-keys "or" '("open rss" . elfeed))
  :init
  (setq elfeed-db-directory (file-name-concat user-emacs-directory "data" "elfeed" "db/")
	elfeed-enclosure-default-dir (file-name-concat user-emacs-directory "data" "elfeed" "enclosures/"))
  :config
  (make-directory elfeed-db-directory t)
  (setq url-queue-time 30)
  (setq elfeed-feeds
	'(("https://www.reddit.com/r/emacs.rss" emacs reddit)
	  ("https://www.reddit.com/r/NixOS.rss" nixos reddit)
	  ("https://www.reddit.com/r/linux.rss" linux reddit)
	  ("https://www.phoronix.com/rss.php" linux)
	  ("https://sachachua.com/blog/feed/" emacs)
	  ("https://karl-voit.at/tags/software/" emacs)
	  ("https://www.redblobgames.com/blog/posts.xml"  game-programming)
	  ("https://fabiensanglard.net/rss.xml" game-programming)
	  ("https://ferd.ca/feed.rss" distributed-systems)
	  ("https://pythonspeed.com/atom.xml" python)
	  ("https://www.b-list.org/feeds/entries/" python)
	  ("https://kobzol.github.io/feed.xml" rust python)
	  ("https://smallcultfollowing.com/babysteps//atom.xml" rust)
	  ("https://nullprogram.com/feed/" c)
	  ("https://mcyoung.xyz/feed.xml" optimization)
	  ("https://news.ycombinator.com/rss" general)
	  ("https://lcamtuf.substack.com/feed" electronics)))
  ;; Split view in elfeed, so the top part is the search buffer and the bottom
  ;; is the view buffer. From: https://karthinks.com/software/lazy-elfeed/
  (defun elfeed-display-buffer (buf &optional act)
    (pop-to-buffer buf)
    (set-window-text-height (get-buffer-window) (round (* 0.60 (frame-height)))))
  (setq elfeed-show-entry-switch #'elfeed-display-buffer
	elfeed-search-remain-on-entry t)
  (defun elfeed-split-show (lines)
    (interactive)
    (with-selected-window (get-buffer-window (elfeed-search-buffer))
      (forward-line lines)
      (hl-line-highlight)
      (call-interactively 'elfeed-search-show-entry)))
  (defun elfeed-split-next () (interactive) (elfeed-split-show +1))
  (defun elfeed-split-prev () (interactive) (elfeed-split-show -1))

  (general-def 'normal 'elfeed-show-mode-map 
    [remap elfeed-show-next] #'elfeed-split-next
    [remap elfeed-show-prev] #'elfeed-split-prev))
(use-package olivetti :general (leader-keys "oz" '("open zen" . olivetti-mode)))
;; (use-package nano-calendar
;;   :vc (:url "https://github.com/rougier/nano-calendar.git" :rev :newest)
;;   :commands (nano-calendar)
;;   :general-config
;;   (general-def 'normal 'nano-calendar-mode-map
;;     "l"   #'nano-calendar-goto-next-day
;;     "h"   #'nano-calendar-goto-prev-day
;;     "j"   #'nano-calendar-goto-next-week
;;     "k"   #'nano-calendar-goto-prev-week
;;     "]]" #'nano-calendar-goto-next-year
;;     "[[" #'nano-calendar-goto-prev-year
;;     ")" #'nano-calendar-goto-next-month
;;     "(" #'nano-calendar-goto-prev-month
;;     "."   #'nano-calendar-goto-today
;;     "q"   #'nano-calendar-quit
;;     "RET" #'nano-calendar-goto-org-agenda))
(use-package hl-todo :hook (prog-mode . hl-todo-mode))
(use-package emacs-everywhere
  :defer t
  :config
  (setq emacs-everywhere-frame-name-format "emacs-anywhere")
  (defun emacs-everywhere--app-info-linux-niri ()
    "Return information on the current active window, on a Linux Niri session."
    (require 'json)
    (let*
	((json-raw (emacs-everywhere--call "niri" "msg" "-j" "focused-window"))
	 (is-err (string-prefix-p "Error" json-raw)))
      (if is-err
	  (progn
	    (message "[emacs-everywhere] %s" json-raw)
	    (message "[emacs-everywhere] NIRI_SOCKET=%s" (getenv "NIRI_SOCKET"))
	    (error "[emacs-everywhere] Error in `niri msg -j focused-window' (see *messages*)"))
	(let*
	    ((json (json-read-from-string json-raw)) ;; -j for json
	     (wid (cdr (assq 'id json)))
	     (window-id (if (numberp wid) (number-to-string wid) wid))
	     (window-title (cdr (assq 'title json)))
	     (app-name (cdr (assq 'app_id json)))
	     (window-geometry nil)) ;; no geometry in niri
	  (make-emacs-everywhere-app
	   :id window-id
	   :class app-name
	   :title window-title
	   :geometry window-geometry))
	)))
  (setq emacs-everywhere-system-configs
	(append emacs-everywhere-system-configs
		'(((wayland . niri)
		   :focus-command ("niri" "msg" "action" "focus-window" "--id" "%w")
		   :info-function emacs-everywhere--app-info-linux-niri)))))
(use-package restart-emacs :commands (restart-emacs))
(use-package ox-hugo
  :after ox
  :config
  (setq org-hugo-base-dir "~/org/site"
	org-hugo-default-section-directory "notes")
  ;; Set of filter functions to adapt ox-hugo to export into zola's
  ;; format. Since I store created and updated date in the properties drawer, an
  ;; extra filter function is needed to parse them out.
  ;; Parses :updated and :date properties in the drawer and inserts it into the front-matter
  (defun my/ox-hugo-filter-dates (info backend)
    (let ((date (org-entry-get 1 "date"))
	  (updated (org-entry-get 1 "updated")))
      (when date
	(setq info (plist-put info :date (replace-regexp-in-string "^\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\).*" "\\1-\\2-\\3" date))))
      (when updated
	(setq info (plist-put info :hugo-lastmod (replace-regexp-in-string "^\\([0-9]\\{4\\}\\)\\([0-9]\\{2\\}\\)\\([0-9]\\{2\\}\\).*" "\\1-\\2-\\3" updated))))
      info))
  ;; Renames from lastmod to updated
  (defun my/ox-hugo-rename-props (text backend info)
    ;; TODO: make these replace first match only, for perf reasons
    ;; To replace only the first match (if any), make REGEXP match up to \'
    ;; and replace a sub-expression, e.g.
    ;;  (replace-regexp-in-string "\\(foo\\).*\\'" "bar" " foo foo" nil nil 1)
    ;;    => " bar foo"
    ;; Could not get the above to work, not sure why

    ;; Rename lastmod to updated and tags to a structure expected by zola
    (setq text (replace-regexp-in-string "^lastmod = " "updated= " text))
    (setq text (replace-regexp-in-string "^tags = " "[taxonomies]\ntags = " text))
    ;; Zola has different link referencing scheme, so we need to change Hugo's to it
    (setq text (replace-regexp-in-string "{{< relref \"\\([^\"]+\\)\" >}}" "@/notes/\\1" text))
    ;; Remove draft = false, we don't need it
    (replace-regexp-in-string "^draft = false\n" "" text))
  ;; Add functions to relevant filter functions
  (setq org-export-filter-options-functions (list #'my/ox-hugo-filter-dates))
  (setq org-export-filter-final-output-functions (list#'my/ox-hugo-rename-props))
  ;; https://github.com/kaushalmodi/ox-hugo/discussions/585#discussioncomment-2335203
  (defun ox-hugo/export-all (&optional org-files-root-dir dont-recurse)
    (interactive)
    (let* ((org-files-root-dir (or org-files-root-dir default-directory))
           (dont-recurse (or dont-recurse (and current-prefix-arg t)))
           (search-path (file-name-as-directory (expand-file-name org-files-root-dir)))
           (org-files (if dont-recurse
                          (directory-files search-path :full "\.org$")
			(directory-files-recursively search-path "\.org$")))
           (num-files (length org-files))
           (cnt 1))
      (if (= 0 num-files)
          (message (format "No Org files found in %s" search-path))
	(progn
          (message (format (if dont-recurse
                               "[ox-hugo/export-all] Exporting %d files from %S .."
                             "[ox-hugo/export-all] Exporting %d files recursively from %S ..")
                           num-files search-path))
          (dolist (org-file org-files)
            (with-current-buffer (find-file-noselect org-file)
              (message (format "[ox-hugo/export-all file %d/%d] Exporting %s" cnt num-files org-file))
              (org-hugo-export-wim-to-md :all-subtrees)
              (setq cnt (1+ cnt))))
          (message "Done!"))))))
(use-package docstr)
;;;; --------------------------- End of the init file ----------------------------
