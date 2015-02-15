(defun lch-mode-line-prepare-left ()
  (let* ((active (powerline-selected-window-active))
         (line-face (if active 'mode-line 'mode-line-inactive))
         (face1 (if active 'powerline-active1 'powerline-inactive1))
         (face2 (if active 'powerline-active2 'powerline-inactive2))
         (state-face (if active (spacemacs/current-state-face) face2))
         (window-numberingp (and (boundp 'window-numbering-mode)
                                 (symbol-value window-numbering-mode)))
         (anzup (and (boundp 'anzu--state) anzu--state))
         (flycheckp (and (boundp 'flycheck-mode)
                         (symbol-value flycheck-mode)
                         (or flycheck-current-errors
                             (eq 'running flycheck-last-status-change))))
         (vc-face (if (or flycheckp spacemacs-mode-line-minor-modesp)
                      face1 line-face))
         (separator-left (intern (format "powerline-%s-%s"
                                         powerline-default-separator
                                         (car powerline-default-separator-dir))))
         (separator-right (intern (format "powerline-%s-%s"
                                          powerline-default-separator
                                          (cdr powerline-default-separator-dir)))))
    (append
     ;; window number
     (if (and window-numberingp (spacemacs/window-number))
         (list (powerline-raw (spacemacs/window-number) state-face))
       (list (powerline-raw (evil-state-property evil-state :tag t) state-face)))
     (if (and active anzup)
         (list (funcall separator-right state-face face1)
               (powerline-raw (anzu--update-mode-line) face1)
               (funcall separator-right face1 line-face))
       (list (funcall separator-right state-face line-face)))
     ;; evil state
     ;; (powerline-raw evil-mode-line-tag state-face)
     ;; (funcall separator-right state-face line-face)
     ;; buffer name
     (list
      (powerline-raw "%*" line-face 'l)
      (powerline-buffer-size line-face 'l)
      (powerline-buffer-id line-face 'l)
      (powerline-raw " " line-face)
      ;; major mode
      (funcall separator-left line-face face1)
      (powerline-major-mode face1 'l)
      (powerline-raw " " face1)
      (when active
        (funcall separator-right face1 line-face)))
     ;; flycheck
     (when (and active flycheckp)
       (list (powerline-raw " " line-face)
             (powerline-raw (spacemacs|custom-flycheck-lighter error)
                            'spacemacs-mode-line-flycheck-error-face)
             (powerline-raw (spacemacs|custom-flycheck-lighter warning)
                            'spacemacs-mode-line-flycheck-warning-face)
             (powerline-raw (spacemacs|custom-flycheck-lighter info)
                            'spacemacs-mode-line-flycheck-info-face)))
     ;; separator between flycheck and minor modes
     (when (and active flycheckp spacemacs-mode-line-minor-modesp)
       (list (funcall separator-left line-face face1)
             (powerline-raw "  " face1)
             (funcall separator-right face1 line-face)))
     ;; minor modes
     (when (and active spacemacs-mode-line-minor-modesp)
       (list (spacemacs-powerline-minor-modes line-face 'l)
             (powerline-raw mode-line-process line-face 'l)
             (powerline-raw " " line-face)))
     ;; version control
     (when (and active (or flycheckp spacemacs-mode-line-minor-modesp))
       (list (funcall separator-left (if vc-face line-face face1) vc-face)))
     (if active
         (list (powerline-vc vc-face)
               (powerline-raw " " vc-face)
               (funcall separator-right vc-face face2))
       (list (funcall separator-right face1 face2))))))

(defun spacemacs/mode-line-prepare-right ()
  (let* ((active (powerline-selected-window-active))
         (line-face (if active 'mode-line 'mode-line-inactive))
         (face1 (if active 'powerline-active1 'powerline-inactive1))
         (face2 (if active 'powerline-active2 'powerline-inactive2))
         (state-face (if active (spacemacs/current-state-face) face2))
         (nyancatp (and (boundp 'nyan-mode) nyan-mode))
         (batteryp (and (boundp 'fancy-battery-mode)
                        (symbol-value fancy-battery-mode)))
         (battery-face (if batteryp (fancy-battery-powerline-face)))
         (separator-left (intern (format "powerline-%s-%s"
                                         powerline-default-separator
                                         (car powerline-default-separator-dir))))
         (separator-right (intern (format "powerline-%s-%s"
                                          powerline-default-separator
                                          (cdr powerline-default-separator-dir)))))
    (append
     ;; battery
     (if (and active batteryp)
         (list (funcall separator-left face2 battery-face)
               (powerline-raw (fancy-battery-default-mode-line)
                              battery-face 'r)
               (funcall separator-right battery-face face1))
       (list (funcall separator-right face2 face1)))
     (list
      ;; row:column
      (powerline-raw " " face1)
      (powerline-raw "%l:%2c" face1 'r)
      (funcall separator-left face1 line-face)
      (powerline-raw " " line-face))
     (list
      ;; global-mode
      (unless (equal '("") global-mode-string)
        (powerline-raw global-mode-string)
        (powerline-raw " " line-face))
      ;; new version
      (if (and active
               spacemacs-new-version
               spacemacs-mode-line-new-version-lighterp)
          (spacemacs-powerline-new-version
           (spacemacs/get-new-version-lighter-face
            spacemacs-version spacemacs-new-version) 'r)))
     (when (and active (not nyancatp))
       (let ((progress (format-mode-line "%p")))
         (list
          ;; percentage in the file
          (powerline-raw "%p" line-face 'r)
          ;; display hud
          (powerline-chamfer-left line-face face1)
          (if (string-match "\%" progress)
              (powerline-hud state-face face1))))))))

(defun spacemacs/mode-line-prepare ()
  (let* ((active (powerline-selected-window-active))
         (face2 (if active 'powerline-active2 'powerline-inactive2))
         (lhs (spacemacs/mode-line-prepare-left))
         (rhs (spacemacs/mode-line-prepare-right))
         (nyancatp (and (boundp 'nyan-mode) nyan-mode)))
    (concat (powerline-render lhs)
            (when (and active nyancatp)
              (powerline-render (spacemacs/powerline-nyan-cat)))
            (powerline-fill face2 (powerline-width rhs))
            (powerline-render rhs))))

(setq-default mode-line-format
              '("%e" (:eval (spacemacs/mode-line-prepare))))
