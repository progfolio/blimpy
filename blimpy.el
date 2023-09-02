;;; blimpy.el --- Type the word "blimpy" in Emacs. ;; -*- lexical-binding: t; -*-

;;; Commentary:
;;

;;; Code:
(defcustom blimpy-before-typing-the-word-blimpy-in-emacs-hook nil
  "Hook run before typing the word blimpy in Emacs.
Run prior to the `blimpy-type-the-word-blimpy-in-emacs' command."
  :type 'hook
  :group 'blimpy)

(defun blimpy--for-each-char (chars callback)
  "Evaluate CALLBACK for each char in CHARS."
  (when-let ((chars)
             (delay 20)
             (randomized (- (random 50) 25))
             (seconds (/ (+ delay randomized) 1000.0)))
    (funcall callback (car chars))
    (run-with-timer seconds nil 'blimpy--for-each-char (cdr chars) callback)))

(defconst blimpy--chars (listify-key-sequence "blimpy "))
(defvar blimpy--char-index -1)

;;;###autoload
(defun blimpy-type-the-word-blimpy-in-emacs (&optional force)
  "Type the word blimpy in Emacs. If FORCE is non-nil, insert with prompting."
  (interactive "P")
  (when (or (equal force '(16))
            (yes-or-no-p "Typing the word blimpy in Emacs may alter the current file. Are you sure you want to type the word blimpy in Emacs?"))
    (run-hooks 'blimpy-before-typing-the-word-blimpy-in-emacs-hook)
    (blimpy--for-each-char blimpy--chars #'insert-char)))

(defun blimpy-self-insert (&rest _)
  "Insert the next character in the word blimpy."
  (list 1 (nth (mod (cl-incf blimpy--char-index) (length blimpy--chars)) blimpy--chars)))

(defun blimpy ()
  "Make it so you can only say `blimpy'."
  (interactive)
  (with-current-buffer (get-buffer-create "*blimpy*")
    (pop-to-buffer (current-buffer))
    (animate-string "YOU CAN ONLY SAY BLIMPY NOW" 20)))

;;;###autoload
(define-minor-mode blimpy-mode
  "Minor mode to type blimpy in Emacs."
  :lighter "blimpy "
  :global t
  :group 'convenience
  (if blimpy-mode
      (progn
        (setq blimpy--char-index -1)
        (advice-add 'self-insert-command :filter-args #'blimpy-self-insert))
    (advice-remove 'self-insert-command #'blimpy-self-insert)))

(provide 'blimpy)

;;; blimpy.el ends here
