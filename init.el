(package-initialize)

; No toolbar in full screen
(tool-bar-mode -1)

(require 'whitespace)
;; (setq whitespace-style '(face empty tabs lines-tail trailing))
(setq whitespace-style '(face empty tabs trailing))
(global-whitespace-mode t)
(setq whitespace-line-column 300)

(setq org-directory "~/Dropbox/org/")
(setq next-line-add-newlines nil)
(load-file "~/.emacs.d/emacs-for-python/epy-init.el")
(setq flymake-gui-warnings-enabled nil)

;; Do not blink cursor
(blink-cursor-mode (- (*) (*) (*)))

;; Delete trailing whitespaces on saving
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun my-other-delete-trailing-blank-lines ()
          "Deletes all blank lines at the end of the file, even the last one"
          (interactive)
          (save-excursion
            (save-restriction
              (widen)
              (goto-char (point-max))
              (delete-blank-lines)
              (let ((trailnewlines (abs (skip-chars-backward "\n\t"))))
                (if (> trailnewlines 0)
                    (progn
                      (delete-char trailnewlines)))))))



;; ORG-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

;; Set to the location of your Org files on your local system
;(setq org-directory "~/org")
;; Set to the name of the file where new notes will be stored
(require 'org)
(setq org-mobile-inbox-for-pull "~/org/flagged.org")
;; Set to <your Dropbox root directory>/MobileOrg.
(setq org-mobile-directory "~/Dropbox/MobileOrg")
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; etags
 (defun create-tags (dir-name)
     "Create tags file."
     (interactive "DDirectory: ")
     (eshell-command
      (format "find %s -type f -name \"*.py\" | etags -" dir-name)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("085b401decc10018d8ed2572f65c5ba96864486062c0a2391372223294f89460" "d2622a2a2966905a5237b54f35996ca6fda2f79a9253d44793cfe31079e3c92b" "71b172ea4aad108801421cc5251edb6c792f3adbaecfa1c52e94e3d99634dee7" default)))
 '(desktop-save-mode t nil (desktop))
 '(ecb-options-version "2.40")
 '(ediff-split-window-function (quote split-window-horizontally))
 '(org-agenda-files (quote ("~/org/1.org")))
 '(save-place t nil (saveplace)))

;; Save desktop (all opened files)
(desktop-save-mode 1)

;; Load all modules
(add-to-list 'load-path "~/.emacs.d/")

;; Pyflakes
(epy-setup-checker "/usr/local/bin/pyflakes %f")

;; Hide toolbar
(tool-bar-mode -1)


;; Ruby development tools
(setq rsense-home "~/.emacs.d/rsense")
(add-to-list 'load-path (concat rsense-home "/etc"))
;(require 'rsense)

;; For sudo
(require 'tramp)
(setq tramp-default-method "scp")


(column-number-mode 1)

(eval-after-load "vc-hooks"
         '(define-key vc-prefix-map "=" 'ediff-revision))

(defun ediff-current-buffer-revision ()
  "Run Ediff to diff current buffer's file against VC depot.
Uses `vc.el' or `rcs.el' depending on `ediff-version-control-package'."
  (interactive)
  (let ((file (or (buffer-file-name)
          (error "Current buffer is not visiting a file"))))
(if (and (buffer-modified-p)
     (y-or-n-p (message "Buffer %s is modified. Save buffer? "
                (buffer-name))))
    (save-buffer (current-buffer)))
(ediff-load-version-control)
(funcall
 (intern (format "ediff-%S-internal" ediff-version-control-package))
 "" "" nil)))

(global-set-key [f6] 'compile)
(setq compilation-ask-about-save nil)


;; Set font
(load-theme 'zenburn t)
(set-face-attribute 'default nil :height 145 :weight 'normal)
(set-default-font "Inconsolata-18")


(defun toggle-window-split ()
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

(define-key ctl-x-4-map "t" 'toggle-window-split)

;; Pydoc
(add-to-list 'load-path "~/.emacs.d/pydoc-info/")
(require 'pydoc-info)

;;(epy-setup-ipython)
;;(global-hl-line-mode t) ;; To enable
;;(set-face-background 'hl-line "black") ;; change with the color that you like
                                        ;; for a list of colors: http://raebear.net/comp/emacscolors.html


;; Auto refresh buffers
(global-auto-revert-mode t)
(setq-default indent-tabs-mode nil)


(defun my-isearch-word-at-point ()
  (interactive)
  (call-interactively 'isearch-forward-regexp))

(defun my-isearch-yank-word-hook ()
  (when (equal this-command 'my-isearch-word-at-point)
    (let ((string (concat "\\<"
                          (buffer-substring-no-properties
                           (progn (skip-syntax-backward "w_") (point))
                           (progn (skip-syntax-forward "w_") (point)))
                          "\\>")))
      (if (and isearch-case-fold-search
               (eq 'not-yanks search-upper-case))
          (setq string (downcase string)))
      (setq isearch-string string
            isearch-message
            (concat isearch-message
                    (mapconcat 'isearch-text-char-description
                               string ""))
            isearch-yank-flag t)
      (isearch-search-and-update))))

(add-hook 'isearch-mode-hook 'my-isearch-yank-word-hook)

;; Winner mode for saving buffers layout
(when (fboundp 'winner-mode)
      (winner-mode 1))

;; Git for emacs
(autoload 'mo-git-blame-file "mo-git-blame" nil t)
(autoload 'mo-git-blame-current "mo-git-blame" nil t)

; Cmd as meta key. Also, need to set caps lock as C system-wide.
(setq mac-command-modifier 'control)
;;(setq mac-control-modifier 'meta)
;;(setq mac-command-modifier 'meta)
;; (setq mac-option-key-is-meta nil)
;; (setq mac-command-key-is-meta t)
;; (setq mac-option-modifier nil)
; Shell - Mx eshell
; M-y to yank in isearch


; C-M-f go to bracket closing or string end.

;; (defun my-horizontal-recenter ()
;;   "make the point horizontally centered in the window"
;;   (interactive)
;;   (let ((mid (/ (window-width) 2))
;;         (line-len (save-excursion (end-of-line) (current-column)))
;;         (cur (current-column)))
;;     (if (< mid cur)
;;         (set-window-hscroll (selected-window)
;;                             (- cur mid)))))
;; (global-set-key (kbd "C-M-l") 'my-horizontal-recenter)


; Registers: C-x r s <reg> - save and C-x r i <reg> to insert
(require 'list-register)
(global-set-key (kbd "C-x r v") 'list-register)
;; C-x r <SPC> R -- C-x r j R -- save buffer/position in register R, and jump back to it
;; C-x r w R -- C-x r j R -- save window configuration in register R, and jump back to it

; M-r reposition cursor

; C-M-a -- go to beginning of the fuction
; C-m-e -- go to end of the function


; Back C-x o
(defun back-window ()
  (interactive)
  (other-window -1))
(global-set-key (kbd "C-x O") 'back-window)

(setq calendar-week-start-day 1)

;; (global-set-key (kbd "C-c <tab>") 'imenu)
(setq python-imenu-make-tree nil)
(setq python-imenu-include-defun-type nil)




  (require 'etags) ;; provides `find-tag-default' in Emacs 21.

  (defun isearch-yank-regexp (regexp)
    "Pull REGEXP into search regexp."
    (let ((isearch-regexp nil)) ;; Dynamic binding of global.
      (isearch-yank-string regexp))
    (isearch-search-and-update))

  (defun isearch-yank-symbol (&optional partialp)
    "Put symbol at current point into search string.

  If PARTIALP is non-nil, find all partial matches."
    (interactive "P")
    (let* ((sym (find-tag-default))
	   ;; Use call of `re-search-forward' by `find-tag-default' to
	   ;; retrieve the end point of the symbol.
	   (sym-end (match-end 0))
	   (sym-start (- sym-end (length sym))))
      (if (null sym)
	  (message "No symbol at point")
	(goto-char sym-start)
	;; For consistent behavior, restart Isearch from starting point
	;; (or end point if using `isearch-backward') of symbol.
	(isearch-search)
	(if partialp
	    (isearch-yank-string sym)
	  (isearch-yank-regexp
	   (concat "\\_<" (regexp-quote sym) "\\_>"))))))

  (defun isearch-current-symbol (&optional partialp)
    "Incremental search forward with symbol under point.

  Prefixed with \\[universal-argument] will find all partial
  matches."
    (interactive "P")
    (let ((start (point)))
      (isearch-forward-regexp nil 1)
      (isearch-yank-symbol partialp)))

  (defun isearch-backward-current-symbol (&optional partialp)
    "Incremental search backward with symbol under point.

  Prefixed with \\[universal-argument] will find all partial
  matches."
    (interactive "P")
    (let ((start (point)))
      (isearch-backward-regexpnil 1)
      (isearch-yank-symbol partialp)))


(global-set-key "\C-x\C-\\" 'goto-last-change)
; Repeat last command C-x z. z to repeat again.

; tags-search - search name in project

; Search a file in project

(defun  disabled-key ()
  "Disables keys"
  (interactive)
  (print "Key is disabled !")
)

;; All arrow keys are disabled
(global-set-key (kbd "<up>")      'disabled-key)
(global-set-key (kbd "<down>")    'disabled-key)
(global-set-key (kbd "<left>")    'disabled-key)
(global-set-key (kbd "<right>")   'disabled-key)


; Copy word under the cursor
(defun get-point (symbol &optional arg)
  "get the point"
  (funcall symbol arg)
  (point)
)
(defun copy-thing (begin-of-thing end-of-thing &optional arg)
  "copy thing between beg & end into kill ring"
  (save-excursion
    (let ((beg (get-point begin-of-thing 1))
          (end (get-point end-of-thing arg)))
      (copy-region-as-kill beg end)))
)
(defun copy-word (&optional arg)
  "Copy words at point into kill-ring"
  (interactive "P")
  (copy-thing 'backward-sexp 'forward-sexp arg)
  ;;(paste-to-mark arg)
)
(global-set-key (kbd "C-c w")         'copy-word)

; C-h for backspace, C-w for backspace word, C-? for help
(global-set-key (kbd "C-?") 'help-command)
(global-set-key (kbd "M-?") 'mark-paragraph)
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-w") 'backward-kill-word)
;;(global-set-key (kbd "C-;") 'universal-argument)


;; Diff buffer with saved file:
;;diff-buffer-with-file
;;ediff-current-file


; C-n, C-p for autocomplete
(yas/global-mode 1)
(require 'auto-complete-config)
(ac-config-default)
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)
(define-key ac-menu-map "\C-o" 'ac-complete)

(setq-default
 ac-sources '(
              ac-source-abbrev
              ;;ac-source-dictionary
              ;;ac-source-symbols
              ;; ac-source-words-in-all-buffer
              ac-source-words-in-buffer
              )
 )
(setq
 ac-auto-show-menu 0.1
 ;; ac-auto-start 3
 ac-menu-height 20
 ac-modes (append ac-modes '(org-mode jde-mode latex-mode ledger-mode mail-mode
message-mode text-mode))
 )





;;(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
;;(require 'yasnippet)

;;(global-set-ke (kbd "C-i") 'yas/expand)
;;(setq yas/also-auto-indent-first-line t)
;;(add-to-list 'load-path "~/.emacs.d/plugins/autocomplete/")
;;(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/autocomplete/ac-dict")


;; (defun undo-line ()
;;   "Like C-u in bash"
;;   (interactive)
;;   (move-beginning-of-line 1)
;;   (kill-line)
;;   (kill-line)
;; )
;; (global-set-key (kbd "C-u") 'undo-line)

;;(add-to-list 'load-path "/usr/local/Cellar/emacs/24.2/Emacs.app/Contents/share/emacs/site-lisp/w3m")
;;(require 'w3m-load)
(setq w3m-use-cookies t)


; M-w to copy line, C-w to delete (without C-a)
(require 'whole-line-or-region)
(whole-line-or-region-mode)


(setq auto-save-interval 100)

; Auto save directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


; Smex
(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                  ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


; Switch between 2 buffers
(defun switch-to-previous-buffer ()
      (interactive)
      (switch-to-buffer (other-buffer (current-buffer) 1)))
(global-set-key (kbd "M-[") 'switch-to-previous-buffer)
(global-set-key (kbd "M-]") 'other-window)


;; (add-to-list 'load-path "~/.emacs.d/org-caldav")
;; (require org-caldav)
;; (setq org-caldav-url "https://www.google.com/calendar/dav")
;; (setq org-caldav-calendar-id "")


;; - Set `org-caldav-files' to the list of org files you would like to
;;   sync. For everything else, you can use the org-icalendar-*
;;   variables, since org-caldav uses that package to generate the
;;   events.
;;
;; - Set `org-caldav-inbox' to an org filename where new entries from
;;   the calendar should be stored.
;;
;; Call `org-caldav-sync' to start the sync. The URL package will ask
;; you for username/password for accessing the calendar.


(defun select-current-word ()
"Select the word under cursor.
“word” here is considered any alphanumeric sequence with “_” or “-”."
 (interactive)
 (let (pt)
   (skip-chars-backward "-_A-Za-z0-9")
   (setq pt (point))
   (skip-chars-forward "-_A-Za-z0-9")
   (set-mark pt)
   (kill-ring-save pt (point))
 ))
;;(global-set-key (kbd "C-c SPC") 'select-current-word)

(global-auto-highlight-symbol-mode t)


(require 'highlight-symbol)
(global-set-key (kbd "C-M-/")  'highlight-symbol-next)
(global-set-key (kbd "C-M-,") 'highlight-symbol-prev)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [(control meta f3)] 'highlight-symbol-query-replace)

;; C-h to backspace in isearch
(add-hook 'isearch-mode-hook
          (lambda ()
            (define-key isearch-mode-map (kbd "C-h") 'isearch-delete-char
)))


(defun next-word ()
   "Move point to the beginning of the next word, past any spaces"
   (interactive)
   (setq pt (point))
   (forward-word)
   (backward-word)
   (message (number-to-string pt))
   (if (equal pt (point))
       (forward-word)
       (forward-word)
       (backward-word))
   )
;; (global-set-key "\M-f" 'next-word)


(defun kill-whole-word ()
  "Removes a word under the cursor."
  (interactive)
  (setq myBoundaries (bounds-of-thing-at-point 'symbol))
  ;; get the beginning and ending positions
  (setq p1 (car myBoundaries))
  (setq p2 (cdr myBoundaries))
  ;; grab it
  (setq myStr (buffer-substring-no-properties p1 p2))
  ;; delete region
  (delete-region p1 p2)
)
(global-set-key (kbd "C-M-d") 'kill-whole-word)


(defun newca ()
  (interactive)
  (setq p1 (point))
  (back-to-indentation)
  (if (= p1 (point))
      (beginning-of-line nil)
  )
)
(global-set-key (kbd "C-a") 'newca)


(defun newcw ()
  (interactive)
  (if (not (equal mark-active nil))
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)
  )
)
(global-set-key (kbd "C-w") 'newcw)


(browse-kill-ring-default-keybindings)

(global-set-key [f5] 'previous-buffer)
(global-set-key [f9] 'rgrep)
(global-set-key [f8] 'ido-switch-buffer)


(require 'idomenu)
(autoload 'idomenu "idomenu" nil t)
(global-set-key (kbd "C-c <tab>") 'idomenu)

(global-set-key (kbd "C-M-u") 'universal-argument)

(global-set-key (kbd "C-x f") 'find-file-in-project)


;; (setq auto-completion-min-chars 4)
;; (setq ac-auto-start 4)

(require 'virtualenv)


(ac-set-trigger-key "TAB")
(setq ac-auto-start nil)



;; Original idea from
;; http://www.opensubscriber.com/message/emacs-devel@gnu.org/10971693.html
(defun comment-dwim-line (&optional arg)
  "Replacement for the comment-dwim command.
        If no region is selected and current line is not blank and we are not at the end of the line,
        then comment current line.
        Replaces default behaviour of comment-dwim, when it inserts comment at the end of the line."
  (interactive "*P")
  (comment-normalize-vars)
  (if (and (not (region-active-p)) (not (looking-at "[ \t]*$")))
      (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    (comment-dwim arg)))
(global-set-key (kbd "C-/") 'comment-dwim-line)







;; ; diff faces
;; (add-hook 'diff-mode-hook
;;           (lambda ()
;;             (set-face-foreground 'diff-header "#f8f8f8") ; italics
;;             (set-face-background 'diff-header "#0e2231")
;;             (set-face-background 'diff-file-header "#0e2231")
;;             (set-face-foreground 'diff-added "#f8f8f8")
;;             (set-face-background 'diff-added "#253b22")
;;             (set-face-foreground 'diff-changed "#f8f8f8")
;;             (set-face-background 'diff-changed "#4a410d")
;;             (set-face-foreground 'diff-context "#f8f8f8")
;;             (set-face-foreground 'diff-removed "#f8f8f8")
;;             (set-face-background 'diff-removed "#420e09")))

; ediff faces
(add-hook 'ediff-load-hook
          (lambda ()
            ;; (set-face-foreground ediff-current-diff-face-A nil)
            ;; (set-face-background ediff-current-diff-face-A "#420e09")
            ;; (set-face-foreground ediff-even-diff-face-A "#aeaeae")
            ;; (set-face-background ediff-even-diff-face-A nil)
            ;; (set-face-foreground ediff-fine-diff-face-A nil)
            ;; (set-face-background ediff-fine-diff-face-A "#613b3a")
            ;; (set-face-foreground ediff-odd-diff-face-A "#aeaeae")
            ;; (set-face-background ediff-odd-diff-face-A nil)
            ;; (set-face-foreground ediff-current-diff-face-B "#35586C")
            ;; (set-face-background ediff-current-diff-face-B "#253b22")
            ;; (set-face-foreground ediff-even-diff-face-B "#aeaeae")
            ;; (set-face-background ediff-even-diff-face-B nil)
            ;; (set-face-foreground ediff-fine-diff-face-B nil)
            ;; Highlighted color of buffer B
            (set-face-background ediff-fine-diff-face-B "#BCD2EE")
            (set-face-foreground ediff-odd-diff-face-B "#aeaeae")
            ;; (set-face-background ediff-odd-diff-face-B nil)
            ;; (set-face-foreground ediff-current-diff-face-C nil)
            ;; (set-face-background ediff-current-diff-face-C "#4a410d")
            ;; (set-face-foreground ediff-even-diff-face-C "#aeaeae")
            ;; (set-face-background ediff-even-diff-face-C nil)
            ;; (set-face-foreground ediff-fine-diff-face-C nil)
            ;; (set-face-background ediff-fine-diff-face-C "#67643d")
            ;; (set-face-foreground ediff-odd-diff-face-C "#aeaeae")
            ;; (set-face-background ediff-odd-diff-face-C nil)
            ))


(setq explicit-shell-file-name "/usr/local/bin/fish")



(defun my-isearch-buffers ()
  "isearch multiple buffers."
  (interactive)
  (multi-isearch-buffers
   (delq nil (mapcar (lambda (buf)
                       (set-buffer buf)
                       (and (not (equal major-mode 'dired-mode))
                            (not (string-match "^[ *]" (buffer-name buf)))
                            buf))
                     (buffer-list)))))

(global-set-key (kbd "C-M-s") 'my-isearch-buffers)
(global-set-key (kbd "M-g") 'recenter-top-bottom)





;; (global-set-key (kbd "C-c v") (kbd "C-x 2 C-x 0 C-u - 1 C-x o"))
(defun halve-other-window-height ()
  "Expand current window to use half of the other window's lines."
  (interactive)
  (split-window-below)
  (enlarge-window (/ (window-height (next-window)) 2)))

(global-set-key (kbd "C-c v") 'halve-other-window-height)

(global-set-key (kbd "C-x b") 'disabled-key)


;; Evil mode
;; (add-to-list 'load-path "~/.emacs.d/evil")
(setq evil-want-C-u-scroll t)
;; (require 'evil)
(evil-mode 1)
(setq evil-auto-indent t)
(setq evil-shift-width 4)
(setq evil-regexp-search t)
(setq evil-want-C-i-jump t)


(defvar server-buffer-clients)
(when (and (fboundp 'server-start) (string-equal (getenv "TERM") 'xterm))
  (server-start)
  (defun fp-kill-server-with-buffer-routine ()
    (and server-buffer-clients (server-done)))
  (add-hook 'kill-buffer-hook 'fp-kill-server-with-buffer-routine))


; Save on MAC-s
(global-set-key (kbd "C-s") 'save-buffer)
(global-set-key (kbd "C-x s") 'save-buffer)


; Easy navigation
(global-set-key (kbd "C-x k") 'windmove-up)
(global-set-key (kbd "C-x j") 'windmove-down)
(global-set-key (kbd "C-x l") 'windmove-right)
(global-set-key (kbd "C-x h") 'windmove-left)

; Remap kill-buffer
(global-set-key (kbd "C-c k") 'kill-buffer)


;; Reserved
;; (global-set-key (kbd "C-x SPC") 'other-window)


;; Try to fix fish emacs rgrep
(grep-compute-defaults)
(grep-apply-setting 'grep-find-command "find . ! -name \"*~\" ! -name \"#*#\" -type f -print0 | xargs -0 -e grep -nH -e ")
(setq grep-find-command "find . ! -name \"*~\" ! -name \"#*#\" -type f -print0 | xargs -0 -e grep -nH -e ")

(require 'package)
;; Add the original Emacs Lisp Package Archive
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
;; Add the user-contributed repository
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
  '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; Toggle the perspective mode
(persp-mode)

;;; esc quits
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

;; How navigation keys
(global-set-key (kbd "C-j") 'other-window)
(global-set-key (kbd "C-;") 'smex)
(global-set-key (kbd "C-k") 'ido-switch-buffer)

(require 'sr-speedbar)
(global-set-key (kbd "C-c s") 'sr-speedbar-toggle)

(setq display-time-day-and-date t display-time-24hr-format t)
(display-time)

(require 'workgroups)
(setq wg-prefix-key (kbd "C-c w"))
(workgroups-mode 1)

(global-ede-mode 1)
(require 'semantic/sb)
(semantic-mode 1)

;;(setq ipython-command "/usr/bin/ipython")
;;(defvaralias 'py-mode-map 'python-mode-map)

; Ecb
(add-to-list 'load-path "~/.emacs.d/ecb/")
(require 'ecb)

(add-hook 'ecb-history-buffer-after-create-hook 'evil-emacs-state)
  (add-hook 'ecb-directories-buffer-after-create-hook 'evil-emacs-state)
  (add-hook 'ecb-methods-buffer-after-create-hook 'evil-emacs-state)
  (add-hook 'ecb-sources-buffer-after-create-hook 'evil-emacs-state)

(setq stack-trace-on-error t)
(setq ecb-tip-of-the-day nil)
(setq ecb-auto-activate t)
(setq ecb-layout-name "left6")
(setq ecb-options-version "2.40")
(setq ecb-source-path (quote ("~/")))

; Debug on error
;;(setq debug-on-error t)

; Nav
;(add-to-list 'load-path "~/.emacs.d/emacs-nav/")
;(require 'nav)
;(nav-disable-overeager-window-splitting)

;;(require 'imenu-tree)
(add-hook 'python-mode-hook 'outline-minor-mode)
(setq projectile-enable-caching t)
(add-hook 'python-mode-hook 'projectile-on)

; Jedi
(add-hook 'python-mode-hook 'jedi:setup)