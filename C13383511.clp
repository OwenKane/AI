(clear)

(deftemplate weather 
	(slot currentWeather)  
	(slot rainfall) 
	(slot temp) 
	(slot rainAmount)
	(slot degree) 
)

;RULES
;rule 1 - weather
(deffunction weather()
    (printout t "What is the weather today? rain or dry: " crlf)
    (bind ?w (read))
    
    (if(= ?w rain) then
        (printout t "What is the rainfall today? High, Low or Medium: " crlf)
        (bind ?y (read))
        (assert (weather (currentWeather ?w) (rainAmount ?y)))
    else
        (assert (weather (currentWeather ?w)))
    ) 
    (run)
)

;rule 2 - rainning
(deffunction rain()
    (printout t "What is the rainfall today? high, medium or low: " crlf)
    (bind ?y (read))
     
    (printout t "To what degree do you believe the rainfall is low? Enter a numeric certainty between 0 and 1.0 inclusive." crlf)
    (bind ?x (read))
       
    (assert(weather (currentWeather rain) (rainAmount ?y) (rainfall ?x)))
    (run)
)

;rule 3 - temperature
(deffunction Temp()
    (printout t "What is the temp today? cold or warm: " crlf)
    (bind ?t (read))
     
    (printout t "To what degree do you believe the temp is cold? Enter a numeric certainty between 0 and 1.0 inclusive." crlf)
    (bind ?x (read))
        
    (assert (weather (currentWeather rain) (rainAmount low) (temp ?t) (degree ?x)))
    (run)
)




(defrule weatherRule-1
    (weather (currentWeather rain) (rainAmount low) (rainfall ?x) (temp nil))
    =>
    (bind ?min (minf1 1.0 ?x))
    (bind ?res (* ?min 0.6))
    (printout t "Tomorrow is dry with certainty of: "?res crlf)
)

(defrule weatherRule-2
    (weather (currentWeather rain) (rainAmount ~nil)(temp ~nil))
    =>
    (bind ?c (* 1.0 0.5))
    (printout t "Tomorrow is rain with certainty of: "?c crlf)
)

(defrule weatheRule-3
    (weather (currentWeather dry) (temp warm) (degree ?x))
    =>
    (bind ?min (minf2 1.0 0.8 ?x))
    (bind ?res (* ?min 0.55))
    (printout t "Tomorrow is rain with certainty of: "?res crlf)
)

(defrule weatheRule-4
    (weather (currentWeather rain) (rainAmount low) (temp cold) (degree ?x))
    =>
    (bind ?min (minf2 1.0 0.8 ?x))
    (bind ?res (* ?min 0.65))
    (printout t "Tomorrow is dry with certainty of: "?res crlf)
)

(defrule weatherRule-5
    (weather (currentWeather dry)(rainAmount ~nil)(temp ~nil))
    =>
    (bind ?c (* 1.0 0.5))
    (printout t "Tomorrow is dry with certainty of: "?c crlf)
)



(deffunction minf1 (?a ?b)
    (if (< ?a ?b) then
        (return ?a)
    else
        (return ?b)
    )
)

(deffunction minf2 ($?args)
    (bind ?min (nth$ 1 ?args))
    (foreach ?a ?args
        (if (< ?a ?min) then (bind ?min ?a))
    )
    (return ?min)
)

(reset)     
(run)   