(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ac-trigger-commands-on-completing
   (append
    (quote
     (c-electric-backspace c-electric-backspace-kill))
    ac-trigger-commands-on-completing))
 '(org-agenda-files (quote ("~/Dropbox/Org/org/iPrv.org")))
 '(org-drill-optimal-factor-matrix nil)
 '(package-selected-packages (quote (yasnippet skewer-mode evil async)))
 '(safe-local-variable-values (quote ((bhj-force-cleanup-buffer . t)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background "Black" :foreground "Cornsilk"))))
 '(mode-line ((t (:foreground "White" :background "DarkRed" :box (:line-width -1 :style released-button)))))
 '(org-level-3 ((t (:inherit outline-3 :foreground "LightBlue")))))
