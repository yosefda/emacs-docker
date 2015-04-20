;; Customizations first

(custom-set-variables
 '(fill-column 80)
 '(haskell-indent-spaces 4)
 '(haskell-process-args-cabal-repl
   (quote
    ("--ghc-options=-ferror-spans" "--with-ghc=ghci-ng")))
 '(haskell-process-auto-import-loaded-modules t)
 '(haskell-process-log t)
 '(haskell-process-path-ghci "ghci-ng")
 '(haskell-process-type (quote cabal-repl))
 '(haskell-stylish-on-save t)
 '(linum-format (quote dynamic))
 '(shm-indent-spaces 4)
 '(tab-stop-list (number-sequence 4 80 4)))


(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(defvar def/packages
  '(flycheck
    flycheck-haskell
    haskell-mode
    undo-tree)
  "List of packages to be installed from archives")

(require 'cl)
(defun x/packages-installed-p ()
  (loop for pkg in def/packages
        when (not (package-installed-p pkg)) do (return nil)
        finally (return t)))

;; Install all missing packages
(unless (x/packages-installed-p)
  (message "%s" "Refreshing packages database…")
  (package-refresh-contents)
  (dolist (pkg def/packages)
    (when (not (package-installed-p pkg))
      (package-install pkg))))


;; Flycheck configuration
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; Disable built-in haskell checker,
;; because of https://github.com/chrisdone/haskell-flycheck
(add-hook
 'haskell-mode-hook
 (lambda () (flycheck-disable-checker 'haskell-ghc)))


;; Haskell support
(add-hook 'haskell-mode-hook #'turn-on-font-lock)
(add-hook 'haskell-mode-hook #'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook #'interactive-haskell-mode)
(add-hook 'haskell-mode-hook #'hindent-mode)

;; SHM
(add-to-list 'load-path "/root/structured-haskell-mode/elips")
(require 'shm)
(add-hook 'haskell-mode-hook #'structured-haskell-mode)

;; Miscellaneous goodies
(add-hook 'prog-mode-hook #'linum-mode)
(column-number-mode t)
(show-paren-mode t)
(add-hook 'package-menu-mode-hook #'hl-line-mode)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(require 'undo-tree)
(global-undo-tree-mode)
