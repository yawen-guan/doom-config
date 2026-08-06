;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; (setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'regular))

(setq doom-font (font-spec :family "Iosevka" :size 25 :weight 'regular))
(setq doom-symbol-font (font-spec :family "Noto Color Emoji" :size 32 :weight 'regular))

;; prefer Iosevka for mathematical character
(after! doom
  (set-fontset-font t 'mathematical
                    (font-spec :family "Iosevka" :size 25)
                    nil 'prepend))


;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
;; (setq doom-theme 'doom-one-light)
;; (setq doom-theme 'doom-tomorrow-night)
;; (setq doom-theme 'doom-tomorrow-day)
(setq doom-theme 'my-doom-tomorrow-day)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
;; (setq display-line-numbers-type t)
(setq display-line-numbers 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq auth-sources '("~/.authinfo.gpg"))

;; See: https://docs.magit.vc/forge/Setup-for-Another-Gitlab-Instance.html
(after! forge
  (push '("gitlab.epfl.ch"              ; GITHOST
          "gitlab.epfl.ch/api/v4"       ; APIHOST
          "gitlab.epfl.ch"              ; WEBHOST / INSTANCE-ID
          forge-gitlab-repository)   ; CLASS
        forge-alist))

(setq pr-review-forges-alist
      '(("github.com" . (github nil nil)) ;; default, reads api-host & username from ghub config
        ("gitlab.com" . (gitlab nil nil))
        ("gitlab.epfl.ch" . (gitlab "gitlab.epfl.ch/api/v4" "yguan"))))

;; = VTerm =====================================================================
(setq vterm-shell (executable-find "zsh"))

;; = Evil ======================================================================
(setq evil-escape-key-sequence "jk"
      evil-escape-delay 0.2) ;; adjust if it's too fast/slow

;; = File ======================================================================
(map! :leader
      (:prefix ("f" . "file")
       :desc "Format and save buffer"     "s" #'+format/save-buffer
       :desc "Save buffer (no reformat)"  "o" #'+format/save-buffer-no-reformat))

;; = Org Mode ==================================================================
(after! org
  ;; bigger latex fragment
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 3.0))
  ;; auto-toggle org latex fragment
  (add-hook 'org-mode-hook 'org-fragtog-mode)
  )

(use-package! org-download
  :after org
  :config
  (setq org-download-method 'directory)
  (setq-default org-download-heading-lvl 'nil)
  (setq org-download-image-org-width 600)
  (setq org-download-link-format "[[file:%s]]\n"
        org-download-abbreviate-filename-function #'file-relative-name)
  (setq org-download-link-format-function #'org-download-link-format-function-default))

;; = Centaur Tabs ==============================================================
(map! :leader
      (:prefix ("a" . "tab") ;; Under "SPC-a"
       :desc "Previous tab"              "h" #'centaur-tabs-backward-tab
       :desc "Next tab"                  "l" #'centaur-tabs-forward-tab
       :desc "Jump to tab"               "j" #'centaur-tabs-ace-jump
       :desc "Kill other buffers"        "o" #'centaur-tabs-kill-other-buffers-in-current-group
       :desc "Kill unmodified buffers"   "u" #'centaur-tabs-kill-unmodified-buffers-in-current-group
       :desc "Kill the current buffer"   "d" (lambda () (interactive) (kill-buffer (current-buffer)))))

;; = Workspaces ================================================================
(map! :leader
      (:prefix "TAB" ;; Under "SPC-TAB"
       :desc "Previous workspace"       "h" #'+workspace/switch-left
       :desc "Next workspace"           "l" #'+workspace/switch-right
       :desc "Jump to workspace"        "j" #'+workspace/switch-to
       ))

;; = Column Indicator ==========================================================
;; auto-toggle column indicator (i.e. get a ruler at column 80)
(setq-default fill-column 80)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'text-mode-hook 'display-fill-column-indicator-mode)
;; exclude coq reponse and goals buffers
(defun disable-fill-column-indicator-mode ()
  (display-fill-column-indicator-mode -1))
(add-hook 'coq-response-mode-hook 'disable-fill-column-indicator-mode)
(add-hook 'coq-goals-mode-hook 'disable-fill-column-indicator-mode)

;; = Ligatures =================================================================
;; Doom Emacs: https://docs.doomemacs.org/v21.12/modules/ui/ligatures/#/usage

;; Enable Iosevka ligatures for programming mode.
(after! ligature
  (ligature-set-ligatures 'prog-mode
                          '(
                            "-<<" "-<" "-<-" "<--" "<---" "<<-" "<-" "->" "->>" "-->" "--->" "->-" ">-" ">>-"
                            "=<<" "=<" "=<=" "<==" "<===" "<<=" "<=" "=>" "=>>" "==>" "===>" "=>=" ">=" ">>="
                            "<->" "<-->" "<--->" "<---->" "<=>" "<==>" "<===>" "<====>" "::" ":::" "__"
                            "<~" "<~~" "<~~~" "</" "</>" "/>" "~>" "~~>" "~~~>" "==" "!=" "/=" "~=" "<>" "===" "!==" "!===" "=/=" "=!="
                            ;; "<:" ": "<".">" .">" "+*" "\=*" "=:" ":>"
                            "(*" "\*)" "/*" "*/" "[|" "|]" "{|" "|}" "++" "+++" "\\/" "/\\" "|-" "-|" "<!--" "<!---"
                            ))

  ;; Enables ligature globally. You can also use `ligature-mode` for specific modes.
  (global-ligature-mode t))

;; = Coq =======================================================================

;; Keybindings

(after! company-coq
  (dolist (state '(normal visual motion))
    (evil-define-key state company-coq-map
      (kbd "SPC d d") #'company-coq-jump-to-definition
      (kbd "SPC d f") #'company-coq-fold
      (kbd "SPC d u") #'company-coq-unfold
      (kbd "SPC d c a x") #'company-coq-lemma-from-goal
      )))

(after! coq-mode
  (dolist (state '(normal visual motion))
    (evil-define-key state coq-mode-map
      (kbd "SPC m s") #'coq-Search
      (kbd "SPC m .") nil ;; unbind the previous proof-goto-point
      (kbd "SPC d l") #'proof-goto-point
      (kbd "SPC m [") nil ;; unbind the previous proof-undo-last-successful-command
      (kbd "SPC d k") #'proof-undo-last-successful-command
      (kbd "SPC m ]") nil ;; unbind the previous proof-assert-next-command-interactive
      (kbd "SPC d j") #'proof-assert-next-command-interactive
      (kbd "SPC m p p") nil ;; unbind the previous proof-process-buffer
      (kbd "SPC d b") #'proof-process-buffer
      )))

;; Proof General

;; Colors
(custom-set-faces!
  '(proof-locked-face    :background "#d1d1e3"))   ;; current locked region

;; Set hybrid window display.
(setq-default proof-three-window-mode-policy 'hybrid)

;; Add more prettify-symbol entries (must run before loading company-coq).
(add-hook 'coq-mode-hook
          (lambda ()
            (setq-local prettify-symbols-alist
                        '((":=" . ?≜)
                          ("Proof." . ?∵)
                          ("Qed." . ?■)
                          ("Defined." . ?□)
                          ;; ("Admitted." . ?🫣)
                          ("\\*" . ?✻)
                          ("\\*+" . ?✢)
                          ))))

;; Remove some entries added by company-coq (must run after loading company-coq).
;;
;; company-coq has the following prettify symbols entries:
;;   ("-->" . ?⟶)
;;   ("<--" . ?⟵)
;;   ("<-->" . ?⟷)
;;   ("==>" . ?⟹)
;;   ("<==" . ?⟸)
;;   ("~~>" . ?⟿)
;;   ("<~~" . ?⬳)
;; However, in Iosevka, the long arrow unicode ⟶ looks like the short arrow
;; unicode →. Under auto-composition-mode, the different arrows are pretty
;; enough, so I will simply remove them from the prettify-symbols-alist.
;; Another way to avoid the confusion is to use different fonts, such as
;; Iosevka Term.
(add-hook 'company-coq-mode-hook
          (lambda ()
            (setq-local prettify-symbols-alist
                        (delq nil
                              (mapcar (lambda (pair)
                                        (if (member (car pair) '("-->" "<--" "<-->" "==>" "<==" "~~>" "<~~"))
                                            nil
                                          pair))
                                      prettify-symbols-alist)))))

;; = Unicode Input =============================================================
;; Check: https://gitlab.mpi-sws.org/iris/iris/-/blob/master/docs/editor.md
(require 'math-symbol-lists)
;; automatically use math input method for Coq files
(add-hook 'coq-mode-hook (lambda () (set-input-method "math")))
                                        ; Input method for the minibuffer
(defun my-inherit-input-method ()
  "Inherit input method from `minibuffer-selected-window'."
  (let* ((win (minibuffer-selected-window))
         (buf (and win (window-buffer win))))
    (when buf
      (activate-input-method (buffer-local-value 'current-input-method buf)))))
(add-hook 'minibuffer-setup-hook #'my-inherit-input-method)
                                        ; Define the actual input method
(quail-define-package "math" "UTF-8" "Ω" t)
(quail-define-rules ; add whatever extra rules you want to define here...
 ("\\fun"    ?λ)
 ("\\mult"   ?⋅)
 ("\\ent"    ?⊢)
 ("\\dent"   ?⊩)
 ("\\valid"  ?✓)
 ("\\diamond" ?◇)
 ("\\box"    ?□)
 ("\\bbox"   ?■)
 ("\\later"  ?▷)
 ("\\pred"   ?φ)
 ("\\and"    ?∧)
 ("\\or"     ?∨)
 ("\\comp"   ?∘)
 ("\\ccomp"  ?◎)
 ("\\all"    ?∀)
 ("\\ex"     ?∃)
 ("\\to"     ?→)
 ("\\pto"    ?↦)
 ("\\rward"  ?↣)
 ("\\sep"    ?∗)
 ("\\lc"     ?⌜)
 ("\\rc"     ?⌝)
 ("\\Lc"     ?⎡)
 ("\\Rc"     ?⎤)
 ("\\lam"    ?λ)
 ("\\empty"  ?∅)
 ("\\Lam"    ?Λ)
 ("\\Sig"    ?Σ)
 ("\\Phi"    ?Φ)
 ("\\ii"     ?Φ) ;; short cut
 ("\\-"      ?∖)
 ("\\aa"     ?●)
 ("\\af"     ?◯)
 ("\\auth"   ?●)
 ("\\frag"   ?◯)
 ("\\iff"    ?↔)
 ("\\gname"  ?γ)
 ("\\incl"   ?≼)
 ("\\latert" ?▶)
 ("\\update" ?⇝)
 ;; accents (for iLöb)
 ("\\\"o" ?ö)
 ("\\req" ?≗)
 ("\\peq" ?≼)
 ;;
 ("\\llc"    ?⟬)
 ("\\rrc"    ?⟭)
 ("\\llb"    ?⟦)
  ("\\rrb"    ?⟧)
 ("\\lcb"    ?⦃)
  ("\\rcb"    ?⦄)
 ("\\llt"    ?⦗)
  ("\\rrt"    ?⦘)
 ("\\lls"    ?⎡)
 ("\\rrs"    ?⎤)
 ("\\lsg"    ?ɣ) ;; latin small letter gamma
 ("\\bb"     ?ϐ)
 ("\\be"     ?▢) ;; empty box
 ("\\bdot"   ?▣)
 ("\\bf"     ?■) ;; fully-filled box
 ("\\bh"     ?▧) ;; half-filled box
 ("\\kop"    ?ϟ)
 ("\\in"     ?∈)
 ("\\circ"   ?∘)
 ("\\cdot"   ?⊙)
 ("\\lsep"   ?┆)
 ("\\cplus"  ?⨁)
 ("\\ctimes" ?⨂)
 ("\\cup"    ?∪)
 ("\\langle" ?⟨)
  ("\\rangle" ?⟩)

 ;; lowercase greek letters
 ("\\ga" ?α) ("\\gb" ?β) ("\\gg" ?γ) ("\\gd" ?δ) ("\\ge" ?ε)
 ("\\gz" ?ζ) ("\\gh" ?η) ("\\gth" ?θ) ("\\gi" ?ι) ("\\gk" ?κ)
 ("\\gl" ?λ) ("\\gm" ?μ) ("\\gn" ?ν) ("\\gxi" ?ξ) ("\\go" ?ο)
 ("\\gp" ?π) ("\\gr" ?ρ) ("\\gs" ?σ) ("\\gt" ?τ) ("\\gu" ?υ)
 ("\\gph" ?φ) ("\\gch" ?χ) ("\\gps" ?ψ) ("\\gw" ?ω)

 ;; uppercase greek letters
 ("\\gA" ?Α) ("\\gB" ?Β) ("\\gG" ?Γ) ("\\gD" ?Δ) ("\\gE" ?Ε)
 ("\\gZ" ?Ζ) ("\\gH" ?Η) ("\\gTH" ?Θ) ("\\gI" ?Ι) ("\\gK" ?Κ)
 ("\\gL" ?Λ) ("\\gM" ?Μ) ("\\gN" ?Ν) ("\\gXI" ?Ξ) ("\\gO" ?Ο)
 ("\\gP" ?Π) ("\\gR" ?Ρ) ("\\gS" ?Σ) ("\\gT" ?Τ) ("\\gU" ?Υ)
 ("\\gPH" ?Φ) ("\\gCH" ?Χ) ("\\gPS" ?Ψ) ("\\gW" ?Ω)

 ;; double-struck lowercase letters
 ("\\bba" ?𝕒) ("\\bbb" ?𝕓) ("\\bbc" ?𝕔) ("\\bbd" ?𝕕) ("\\bbe" ?𝕖)
 ("\\bbf" ?𝕗) ("\\bbg" ?𝕘) ("\\bbh" ?𝕙) ("\\bbi" ?𝕚) ("\\bbj" ?𝕛)
 ("\\bbk" ?𝕜) ("\\bbl" ?𝕝) ("\\bbm" ?𝕞) ("\\bbn" ?𝕟) ("\\bbo" ?𝕠)
 ("\\bbp" ?𝕡) ("\\bbq" ?𝕢) ("\\bbr" ?𝕣) ("\\bbs" ?𝕤) ("\\bbt" ?𝕥)
 ("\\bbu" ?𝕦) ("\\bbv" ?𝕧) ("\\bbw" ?𝕨) ("\\bbx" ?𝕩) ("\\bby" ?𝕪)
 ("\\bbz" ?𝕫)

 ;; double-struck uppercase letters
 ("\\bbA" ?𝔸) ("\\bbB" ?𝔹) ("\\bbC" ?ℂ) ("\\bbD" ?𝔻) ("\\bbE" ?𝔼)
 ("\\bbF" ?𝔽) ("\\bbG" ?𝔾) ("\\bbH" ?ℍ) ("\\bbI" ?𝕀) ("\\bbJ" ?𝕁)
 ("\\bbK" ?𝕂) ("\\bbL" ?𝕃) ("\\bbM" ?𝕄) ("\\bbN" ?ℕ) ("\\bbO" ?𝕆)
 ("\\bbP" ?ℙ) ("\\bbQ" ?ℚ) ("\\bbR" ?ℝ) ("\\bbS" ?𝕊) ("\\bbT" ?𝕋)
 ("\\bbU" ?𝕌) ("\\bbV" ?𝕍) ("\\bbW" ?𝕎) ("\\bbX" ?𝕏) ("\\bbY" ?𝕐)
 ("\\bbZ" ?ℤ)

 ;; calligraphic lowercase letters
 ("\\cla" ?𝒶) ("\\clb" ?𝒷) ("\\clc" ?𝒸) ("\\cld" ?𝒹) ("\\cle" ?ℯ)
 ("\\clf" ?𝒻) ("\\clg" ?ℊ) ("\\clh" ?𝒽) ("\\cli" ?𝒾) ("\\clj" ?𝒿)
 ("\\clk" ?𝓀) ("\\cll" ?ℓ) ("\\clm" ?𝓂) ("\\cln" ?𝓃) ("\\clo" ?ℴ)
 ("\\clp" ?𝓅) ("\\clq" ?𝓆) ("\\clr" ?𝓇) ("\\cls" ?𝓈) ("\\clt" ?𝓉)
 ("\\clu" ?𝓊) ("\\clv" ?𝓋) ("\\clw" ?𝓌) ("\\clx" ?𝓍) ("\\cly" ?𝓎)
 ("\\clz" ?𝓏)

 ;; calligraphic uppercase letters
 ("\\clA" ?𝒜) ("\\clB" ?ℬ) ("\\clC" ?𝒞) ("\\clD" ?𝒟) ("\\clE" ?ℰ)
 ("\\clF" ?ℱ) ("\\clG" ?𝒢) ("\\clH" ?ℋ) ("\\clI" ?ℐ) ("\\clJ" ?𝒥)
 ("\\clK" ?𝒦) ("\\clL" ?ℒ) ("\\clM" ?ℳ) ("\\clN" ?𝒩) ("\\clO" ?𝒪)
 ("\\clP" ?𝒫) ("\\clQ" ?𝒬) ("\\clR" ?ℛ) ("\\clS" ?𝒮) ("\\clT" ?𝒯)
 ("\\clU" ?𝒰) ("\\clV" ?𝒱) ("\\clW" ?𝒲) ("\\clX" ?𝒳) ("\\clY" ?𝒴)
 ("\\clZ" ?𝒵)

 ;; subscripts and superscripts
 ("^^+" ?⁺) ("__+" ?₊) ("^^-" ?⁻)
 ("__0" ?₀) ("__1" ?₁) ("__2" ?₂) ("__3" ?₃) ("__4" ?₄)
 ("__5" ?₅) ("__6" ?₆) ("__7" ?₇) ("__8" ?₈) ("__9" ?₉)

 ("__a" ?ₐ) ("__e" ?ₑ) ("__h" ?ₕ) ("__i" ?ᵢ) ("__k" ?ₖ)
 ("__l" ?ₗ) ("__m" ?ₘ) ("__n" ?ₙ) ("__o" ?ₒ) ("__p" ?ₚ)
 ("__r" ?ᵣ) ("__s" ?ₛ) ("__t" ?ₜ) ("__u" ?ᵤ) ("__v" ?ᵥ) ("__x" ?ₓ)

 ("^^b" ?ᵇ) ("^^i" ?ⁱ)
 ("^^B" ?ᴮ) ("^^I" ?ᴵ)
 )
;; (mapc (lambda (x)
;;         (if (cddr x)
;;             (quail-defrule (cadr x) (car (cddr x)))))
;;                                         ; need to reverse since different emacs packages disagree on whether
;;                                         ; the first or last entry should take priority...
;;                                         ; see <https://mattermost.mpi-sws.org/iris/pl/46onxnb3tb8ndg8b6h1z1f7tny> for discussion
;;       (reverse (append math-symbol-list-basic math-symbol-list-extended)))


;; = Treemacs ==================================================================

(after! treemacs

  (defun treemacs-ignore-coq-generated-files (filename absolute-path)
    "Ignore coq-generated files in treemacs."
    (or (string-match-p "\\.\\(vos\\|vok\\|vo\\|glob\\|aux\\)$" filename)
        (string-equal filename ".lia.cache")))

  (add-to-list 'treemacs-ignored-file-predicates #'treemacs-ignore-coq-generated-files))

;; = Whitespace ================================================================
;; (setq-default show-trailing-whitespace t)

(add-hook 'prog-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'delete-trailing-whitespace nil t)))

(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; = Windows ===================================================================

(defun find-file-other-window-left ()
  "Split the current window vertically, open a file in the left window while keeping focus on the original window."
  (interactive)
  (let ((filename (read-file-name "Find file: "))  ;; Prompt for file first
        (original-window (selected-window)))       ;; Store the current (right) window
    (let ((new-window (split-window (selected-window) (- (floor (window-width) 2)) 'left)))
      (select-window new-window)   ;; Move to the new left window
      (find-file filename)         ;; Open the selected file
      (select-window original-window)))) ;; Return focus to the original right window

(map! :leader
      (:prefix "f" ;; Under "SPC-f"
       :desc "Find file in left window" "h" #'find-file-other-window-left))

;; = Tex =======================================================================

(setq TeX-command-extra-options "-file-line-error -shell-escape -synctex=1")
(setq latex-run-command "texfot latexmk -pdf -auxdir=_build/ -emulate-aux-dir -bibtex -silent")

(use-package! key-chord
  :config
  (key-chord-mode 1)

  (defun my/latex-insert-italic ()
    "Insert \\textit{} and move cursor inside."
    (interactive)
    (insert "\\textit{}")
    (backward-char 1))

  (defun my/latex-insert-inline-code ()
    "Insert \\texttt{} and move cursor inside."
    (interactive)
    (insert "\\texttt{}")
    (backward-char 1))

  (defun my/latex-insert-inline-math ()
    "Insert \\(\\) and move cursor inside."
    (interactive)
    (insert "\\(\\)")
    (backward-char 2))

  ;; My custom prefix map for 'ii'
  (defvar my/latex-ii-map (make-sparse-keymap)
    "Keymap triggered by double 'i' chord in LaTeX mode.")

  (define-key my/latex-ii-map (kbd "i") #'my/latex-insert-italic)
  (define-key my/latex-ii-map (kbd "c") #'my/latex-insert-inline-code)
  (define-key my/latex-ii-map (kbd "m") #'my/latex-insert-inline-math)

  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (key-chord-define-local "ii" my/latex-ii-map))))

;; = Visual-Line Mode ==========================================================

(setq visual-fill-column-width 80)

(after! tex
  (add-hook 'TeX-mode-hook #'visual-line-mode)
  (add-hook 'TeX-mode-hook #'visual-fill-column-mode))

(after! latex
  (add-hook 'LaTeX-mode-hook
            (lambda ()
              (setq display-fill-column-indicator-column 75))))

(after! magit
  (add-hook 'magit-status-mode-hook #'visual-line-mode))

;; = Graphviz ==================================================================

(use-package! graphviz-dot-mode)

;; = Haskell ===================================================================

;; (after! apheleia
;;   ;; Define the ormolu formatter
;;   (setf (alist-get 'ormolu apheleia-formatters)
;;         '("ormolu" "--stdin-input-file" filepath))

;;   ;; Tell Apheleia to use it for Haskell
;;   (setf (alist-get 'haskell-mode apheleia-mode-alist) 'ormolu)
;;   (setf (alist-get 'literate-haskell-mode apheleia-mode-alist) 'ormolu))

;; = Obsidian ==================================================================

(use-package! obsidian
  :after markdown-mode
  :init
  ;; Location of obsidian vault
  (setq obsidian-directory "~/Documents/notes")

  :config
  ;; Where new notes go
  (setq obsidian-inbox-directory "inbox")

  ;; Enable wiki-links in markdown buffers
  (setq markdown-enable-wiki-links t)

  ;; Turn on obsidian-mode automatically for notes in the vault
  (add-hook 'markdown-mode-hook
            (lambda ()
              (when (and buffer-file-name
                         (string-prefix-p (expand-file-name obsidian-directory)
                                          (expand-file-name buffer-file-name)))
                (obsidian-mode 1))))

  ;; Backlinks buffer integration
  (add-hook 'obsidian-mode-hook #'obsidian-backlinks-mode)

  ;; Keybindings
  (map! :map obsidian-mode-map
        :localleader
        "n" #'obsidian-capture
        "l" #'obsidian-insert-link
        "o" #'obsidian-follow-link-at-point
        "p" #'obsidian-jump
        "b" #'obsidian-backlink-jump))

;; = Emoji =====================================================================
(after! emojify
  (global-emojify-mode -1))
