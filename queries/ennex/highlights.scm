;; queries/ennex/highlights.scm

;; —————————————————————————————————————————————————
;; Keywords (literal tokens)
;; —————————————————————————————————————————————————
("fn"       @keyword)
("enum"     @keyword)
("let"      @keyword)
("mut"      @keyword)
("pub"      @keyword)
("return"   @keyword)
("if"       @keyword)
("else"     @keyword)
("match"    @keyword)
("from"     @keyword)
("use"      @keyword)

;; —————————————————————————————————————————————————
;; Built-in types
;; —————————————————————————————————————————————————
("string"   @type.builtin)
("number"   @type.builtin)
("boolean"  @type.builtin)
("void"     @type.builtin)

;; —————————————————————————————————————————————————
;; Function declarations  
;;   – pick the identifier immediately after 'fn'
;; —————————————————————————————————————————————————
(function_decl
  (identifier) @function.definition)

;; —————————————————————————————————————————————————
;; Variable declarations  
;;   – pick the identifier after 'let' or 'mut'
;; —————————————————————————————————————————————————
(variable_decl
  (identifier) @variable)

;; —————————————————————————————————————————————————
;; Parameters  
;;   – identifier inside a parameter node
;; —————————————————————————————————————————————————
(parameter
  (identifier) @variable.parameter)

;; —————————————————————————————————————————————————
;; Enum variants  
;;   – identifier in variant declarations
;; —————————————————————————————————————————————————
(variant
  (identifier) @type)

;; —————————————————————————————————————————————————
;; Literals  
;; —————————————————————————————————————————————————
(number)    @number
(string)    @string

;; —————————————————————————————————————————————————
;; Comments  
;; —————————————————————————————————————————————————
(comment)   @comment
