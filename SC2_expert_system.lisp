
;;; ---------DATA---------

(defvar *AGGRO-REF* '((zergling . 0.5) (bane . 1) (roach . 2)))



;;; 3 different starting fact base.

;;; Zerglings rush => Make a marine and build a bunker
;;; If the ennemy is ont the way => only 1 command_center (cancel expand)
(defvar *FACTBASE* '((timing . 180) (aggressivity . 0) (hatchery . 3) (pool . 1) (queen . 1) (roach_waren . 0) (zergling . 3) (bane . 0) (roach . 0) (mutalisk . 0)))

;;; mutalisks => build missile turrets
;(defvar *FACTBASE* '((timing . 200) (aggressivity . 0) (hatchery . 2) (pool . 1) (queen . 1) (roach_waren . 1) (zergling . 3) (bane . 0) (roach . 4) (mutalisk . 0)))

;;; Roach rush => make a cyclone and a tank
; (defvar *FACTBASE* '((timing . 335) (aggressivity . 0) (hatchery . 3) (pool . 1) (queen . 1) (roach_waren . 0) (zergling . 3) (bane . 0) (roach . 0) (mutalisk . 4)))

(defvar *OBJECTIVEBASE* '(
  (SCV 0) (command_center 0) (refinery 0)     ; Eco
  (barracks 0) (factory 0) (starport 0)       ; Prod
  (bunker 0) (missile_turret 0)               ; Def
  (marine 0) (marauder 0)  (medivac 0)        ; Bio
  (hellion 0) (widow_mine 0) (tank 0)         ; Mech
  (cyclone 0) (hellbat 0)                     ; Mech
  (banshee 0) (viking 0)                      ; Air
  (engineering_bay 0) (armory 0)))            ; Up

;;; global variable that contains the path to the current state of research
(defvar *glob_path* ())
;;; global variable that contains the current rule
(defvar *current_rule* ())
;;; global variable that contains the already applied rules
(defvar *already_applied_rules* ())

;;; to be added: (ghost . 0) (raven . 0) (battlecruiser . 0) (ghost_academy . 0)

;;; Rule base:
;;; condition: executable expression
;;; consequence: executable expression
;;; rule: (RULENAME (condition1 condition2) (consequence1 consequence2) "optional description")

(setq ex_rule '(R1 ((eq (getFactValue 'hatchery) 3) (eq (getFactValue 'queen) 0)) ((setObjectiveValue 'bunker 1 *glob_path*) (setFactValue 'build_description "zergling rush"))))

(defvar *RULEBASE_GENERAL* '(
  ;; GENERAL
  (R201 ((< (getFactValue 'timing) 210)) ((setObjectiveValue 'SCV 15)))
  (R202 ((< (getFactValue 'timing) 300) (> (getFactValue 'timing) 210)) ((setObjectiveValue 'command_center 2)))
  (R203 ((>= (getFactValue 'timing) 210) (< (getFactValue 'timing) 301)) ((setObjectiveValue 'SCV 30)))
  (R204 ((< (getFactValue 'timing) 210)) ((setObjectiveValue 'marine 4)))
  (R205 ((< (getFactValue 'timing) 240) (> (getFactValue 'timing) 210)) ((setObjectiveValue 'marine 16)))
  (R206 ((< (getFactValue 'timing) 360) (> (getFactValue 'timing) 300)) ((setObjectiveValue 'command_center 3)))
  (R207 ((>= (getFactValue 'timing) 320)) ((setObjectiveValue 'SCV 60)))
))

(defvar *RULEBASE_STRATEGIES* '(
  ;; STRATEGIES
  (R2 ((> (getFactValue 'timing) 210) (> (getFactValue 'bane) 0)) ((setObjectiveValue 'bunker 1 *glob_path*) (setObjectiveValue 'hellion 1 *glob_path*) (setFactValue 'build_description "baneling rush"))) ; rush baneling
  (R1 ((> (getFactValue 'timing) 150) (< (getFactValue 'timing) 210) (> (getFactValue 'hatchery) 1) (< (getFactValue 'queen) 2)) ((setObjectiveValue 'bunker 1 *glob_path*) (setFactValue 'build_description "zergling rush")))  ; rush zerglings
  (R3 ((> (getFactValue 'timing) 150) (< (getFactValue 'timing) 210) (> (getFactValue 'roach_waren) 0)) ((setObjectiveValue 'bunker 1 *glob_path*) (setObjectiveValue 'cyclone 1 *glob_path*) (setObjectiveValue 'tank 1 *glob_path*) (setFactValue 'build_description "roach rush"))) ;rush roaches
  (R4 ((> (getFactValue 'timing) 210) (< (getFactValue 'timing) 240) (> (getFactValue 'hatchery) 5)) ((setObjectiveValue 'banshee 1 *glob_path*)))
  (R5 ((> (getFactValue 'timing) 210) (< (getFactValue 'timing) 240) (> (getFactValue 'zergling) 10)) ((setObjectiveValue 'hellbat 1 *glob_path*)))
  (R6 ((> (getFactValue 'mutalisk) 0)) ((setObjectiveValue 'missile_turret 1 *glob_path*)))
  (R11 ((equal (getFactValue 'build_description) "zergling rush") (< (getFactValue 'zergling) 4)) ((setObjectiveValue 'command_center 1 *glob_path*)))  ; the opponent already sent his zerlings
))

(defvar *RULEBASE_DEPENDANCES* '(
  ;; DEPENDANCES
  (R101 ((> (getObjectiveValue 'bunker) 0) (= (getObjectiveValue 'barracks) 0)) ((setObjectiveValue 'barracks 1)))
  (R102 ((> (getObjectiveValue 'SCV) 0) (= (getObjectiveValue 'command_center) 0)) ((setObjectiveValue 'command_center 1)))
  (R103 ((> (getObjectiveValue 'marine) 0) (= (getObjectiveValue 'barracks) 0)) ((setObjectiveValue 'barracks 1)))
  (R104 ((> (getObjectiveValue 'missile_turret) 0) (= (getObjectiveValue 'engineering_bay) 0)) ((setObjectiveValue 'engineering_bay 1)))
  (R105 ((> (getObjectiveValue 'marauder) 0) (= (getObjectiveValue 'barracks) 0)) ((setObjectiveValue 'barracks 1)))
  (R106 ((> (getObjectiveValue 'medivac) 0) (= (getObjectiveValue 'starport) 0)) ((setObjectiveValue 'starport 1)))
  (R107 ((> (getObjectiveValue 'hellion) 0) (= (getObjectiveValue 'factory) 0)) ((setObjectiveValue 'factory 1)))
  (R108 ((> (getObjectiveValue 'widow_mine) 0) (= (getObjectiveValue 'factory) 0)) ((setObjectiveValue 'factory 1)))
  (R109 ((> (getObjectiveValue 'tank) 0) (= (getObjectiveValue 'factory) 0)) ((setObjectiveValue 'factory 1)))
  (R110 ((> (getObjectiveValue 'cyclone) 0) (= (getObjectiveValue 'factory) 0)) ((setObjectiveValue 'factory 1)))
  (R111 ((> (getObjectiveValue 'hellbat) 0) (= (getObjectiveValue 'factory) 0) (= (getObjectiveValue 'armory) 0)) ((setObjectiveValue 'factory 1) (setObjectiveValue 'armory 1)))
  (R112 ((> (getObjectiveValue 'banshee) 0) (= (getObjectiveValue 'starport) 0)) ((setObjectiveValue 'starport 1)))
  (R113 ((> (getObjectiveValue 'viking) 0) (= (getObjectiveValue 'starport) 0)) ((setObjectiveValue 'starport 1)))
  (R114 ((> (getObjectiveValue 'barracks) 0) (= (getObjectiveValue 'command_center) 0)) ((setObjectiveValue 'command_center 1)))
  (R115 ((> (getObjectiveValue 'engineering_bay) 0) (= (getObjectiveValue 'barracks) 0)) ((setObjectiveValue 'barracks 1)))
  (R116 ((> (getObjectiveValue 'factory) 0) (= (getObjectiveValue 'barracks) 0)) ((setObjectiveValue 'barracks 1)))
))



;;; ---------SERVICE FUNCTIONS---------

(defun getAggroValue (key) (cdr (assoc key *AGGRO-REF*)))

(defun getFactValue (key) (cdr (assoc key *FACTBASE*)))

(defun getObjectiveValue (key) (cadr (assoc key *OBJECTIVEBASE*)))

(defun setFactValue (key value)
  (if (assoc key *FACTBASE*)
    (setf (cdr (assoc key *FACTBASE*)) value)   ; must use directly assoc here, getFactValue wouldn't work for setf
    (if *FACTBASE*
      (push (cons key value) *FACTBASE*)
      (setq *FACTBASE* (list cons key value))
    )
  )
)

(defun setObjectiveValue (key value &optional path)
  (if (assoc key *OBJECTIVEBASE*)
    (progn
      (setf (cadr (assoc key *OBJECTIVEBASE*)) value)   ; must use directly assoc here, getObjective Value wouldn't work for setf
      (when path
        (nconc (assoc key *OBJECTIVEBASE*) (list path))
      )
    )
    (if *OBJECTIVEBASE*
      (push (list key value path) *OBJECTIVEBASE*)
      (when path
        (setq *OBJECTIVEBASE* (list (list key value path)))
      )
    )
  )
)

(defun getRuleName (rule) (car rule))
(defun getRuleConditions (rule) (cadr rule))
(defun getRuleConsequences (rule) (caddr rule))


(defun setAgrressivity ()
  (loop :for (key . value) :in *AGGRO-REF* :do
    (setFactValue 'aggressivity (+ (getFactValue 'aggressivity) (* (getFactValue key) value)))
  )
)


(defun isApplyable (rule)
  (loop :for condition :in (getRuleConditions rule) :do
    (when (not (eval condition))
      (return-from isApplyable nil))
  )
  t
)

(defun applyRule (rule)
  (loop :for consequence :in (getRuleConsequences rule) :do
    (eval consequence)
  )
)



;;; ---------EXPERT SYSTEM---------

(defun candidateRules (used_rules rule_base)
	(loop :for rule :in rule_base
		:when (and (not (member (getRuleName rule) used_rules)) (isApplyable rule))
      :collect rule
	)
)


(defun engine (path rule_base)  ; /!\ the path is reversed
  (loop :for rule :in (candidateRules path rule_base) :do
    (setq *glob_path* (reverse (cons (getRuleName rule) path)))  ; updates  *glob_path* for the rule application
    (when (not (member (getRuleName rule) *already_applied_rules*))
      (applyRule rule)
      (push (getRuleName rule) *already_applied_rules*)
    )
    (engine (cons (getRuleName rule) path) rule_base)
  )
)

(defun scout ()
  (setAgrressivity)
  (engine () *RULEBASE_GENERAL*)
  (engine () *RULEBASE_STRATEGIES*)
  (engine () *RULEBASE_DEPENDANCES*)
)


(scout)

(loop :for obj :in *OBJECTIVEBASE* :do (print obj))
