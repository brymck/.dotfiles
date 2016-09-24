;; global variables
(setq
 inhibit-startup-screen t
 create-lockfiles nil
 make-backup-files nil
 column-number-mode t
 scroll-error-top-bottom t
 show-paren-delay 0.5
 use-package-always-ensure t
 sentence-end-double-space nil)

;; buffer local variables
(setq-default
 indent-tabs-mode nil
 tab-width 4
 c-basic-offset 4)

;; modes
(electric-indent-mode 0)

;; global keybindings
(global-unset-key (kbd "C-z"))

;; the package manager
(require 'package)
(setq
 package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                    ("org" . "http://orgmode.org/elpa/")
                    ("melpa" . "http://melpa.org/packages/")
                    ("melpa-stable" . "http://stable.melpa.org/packages/")))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;; ensime
(use-package ensime
  :pin melpa-stable)
(add-to-list 'exec-path "/usr/local/bin")

;; neotree
(use-package neotree)

;; change windows with shift + arrow keys
(windmove-default-keybindings)

;; evil
(use-package evil
  :demand)
(evil-mode 1)

(setq evil-want-C-u-scroll t)

;; remap insert, normal and visual modes
(defun evil-map-all (keys def)
  "This function maps a key combination in all standard modes for Evil.
KEYS is the desired key combination and DEF is the function to which
it's bound."
  (define-key evil-insert-state-map keys def)
  (define-key evil-motion-state-map keys def)
  (define-key evil-normal-state-map keys def)
  (define-key evil-visual-state-map keys def))

;; make things slightly less evil
(evil-map-all "\C-b" 'evil-backward-char)
(evil-map-all "\C-e" 'end-of-line)
(evil-map-all "\C-f" 'evil-forward-char)
(evil-map-all "\C-k" 'kill-line)
(evil-map-all "\C-n" 'evil-next-line)
(evil-map-all "\C-p" 'evil-previous-line)
(evil-map-all "\C-y" 'yank)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (neotree evil ensime use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
