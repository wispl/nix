;;; early-init.el -*- lexical-binding: t; -*-

;; Set really high threshold for fast startup
(setq gc-cons-threshold most-positive-fixnum)

;; Optimization stolen from Doom
(defvar old-file-name-handler file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Set threshold back after loading, along with a smaller percentage. Also set
;; the file name handler back to its old original value.
(add-hook 'after-init-hook (lambda() (setq gc-cons-threshold (* 16 1024 1024)
					   gc-cons-percentage 0.2 file-name-handler-alist
					   old-file-name-handler)))
;; Remove some UI elements
;; This uses Doom's hack in order to avoid frame manipulations
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq menu-bar-mode nil
      tool-bar-mode nil
      scroll-bar-mode nil)
;; Adding padding
;; https://www.gnu.org/software//emacs/manual/html_node/modus-themes/DIY-Use-more-spacious-margins-or-padding-in-Emacs-frames.html
(push '(internal-border-width . 35) default-frame-alist)

;; Do not do implicit resizes which cause frame re-renders, especially on some
;; windowing systems and also on font changes
(setq frame-inhibit-implied-resize t)

;; Small improvement to start up times
(setq site-run-file nil
      inhibit-default-init t)

;; Quiet startup
(setq inhibit-startup-message t
      inhibit-splash-screen t
      initial-major-mode 'fundamental-mode
      initial-scratch-message nil)
(advice-add #'display-startup-echo-area-message :override #'ignore)
(advice-add #'display-startup-screen :override #'ignore)

;; Annoying optimizations
;;
;; These optimizations can be annoying but I set them because it helps
;; with the obnoxious white flash when first starting up
;; emacs. Although I still get flashes of light, at least the interval
;; is much shorter.
;;
;; Edit: I actually fixed the issue by setting the gtk theme...
;; leaving this here for history

;; From Doom
;; This has the caveat that when first downloading packages and stuff,
;; emacs stays as in an unitialized stage until it finishes
(setq-default inhibit-redisplay t
	      inhibit-message t)
(defun doom--reset-inhibited-vars-h ()
  (setq-default inhibit-redisplay nil
                inhibit-message nil)
  (remove-hook 'after-init-hook #'doom--reset-inhibited-vars-h))
(add-hook 'after-init-hook #'doom--reset-inhibited-vars-h -100)

;; From Doom
;; Hides modeline until something like doom-modeline sets it
;; This fixes seeing flashes of the original modeline on startup 
(setq-default mode-line-format nil)
(dolist (buf (buffer-list))
  (with-current-buffer buf (setq mode-line-format nil)))
