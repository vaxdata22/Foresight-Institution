-----------------------------------------------
-- DATA EXPLORATION PHASE USING T-SQL----------
-----------------------------------------------

-- zone where the instution can be found
SELECT zone FROM Zones$


-- number of study centers in the institution
SELECT COUNT(DISTINCT [study center]) AS no_of_studycenter
FROM StudyCenters$;


-- states where the study centers are found
SELECT DISTINCT st.state
FROM StudyCenters$ s
INNER JOIN States$ st
ON s.ID = st.ID
ORDER BY state;


-- the name of the programe that is being run in the campus
SELECT ID, [programme Name]
FROM Programmes$
GROUP BY  ID, [programme Name]


-- the academic session in the institution
SELECT session AS session
FROM AcademicSessions$


-- the total number of specialization in the institution
SELECT COUNT(DISTINCT Specialization) AS number_of_specialization
FROM Specializations$


-- the specialization in the institution
SELECT DISTINCT Specialization
FROM Specializations$


-- the number of specialization in the institution BY status
SELECT status, COUNT([status]) AS number_of_specialization
FROM Specializations$
GROUP BY [status]


--number of specialization that have practical in the institution
SELECT Practical, COUNT(DISTINCT specialization) AS number_of_specialization 
FROM Specializations$
GROUP BY Practical


-- programmes offered in the institution
SELECT DISTINCT [Programme Name] 
FROM Programmes$


 -- total number of applicant 
 SELECT COUNT(ap.ID) AS total_applicant
 FROM Admissions$ ad
 INNER JOIN Applicants$ ap
 ON ad.id = ap.ID
 

--the entry type used BY the institution
  SELECT DISTINCT entry_type AS entry_type
 FROM Admissions$ ad
 INNER JOIN Applicants$ ap
 ON ad.id = ap.ID



 -- the programme durations offered BY the institution
  SELECT [Program Duration]
 FROM Admissions$ ad
 INNER JOIN Applicants$ ap
 ON ad.id = ap.ID
 GROUP BY [Program Duration]
 ORDER BY [Program Duration] DESC


 -- the kind of fee that is charged in the institution
 SELECT FeeType FROM 
 FeesTypes$


 -- total number of students FROM all specializations
SELECT sum(number_of_students) AS number_of_students 
FROM (SELECT Specialization, COUNT(s.ID) AS number_of_students 
	FROM Students$ s
	INNER JOIN Specializations$ sp 
	on s.SpecalizationID = sp.id
	GROUP BY Specialization
	) t


-- total number of students in the institution
SELECT COUNT(*) AS number_of_students FROM Students$


-- total number of applicants admitted in the institution
SELECT COUNT(*) AS number_of_applicant_admitted FROM Admissions$


-- total number of applicants that applied to the institution
SELECT COUNT(*) AS number_of_applicant_applied FROM Applicants$


-- applicants admission percent in the institution
SELECT ROUND(CAST(COUNT(ad.id) AS FLOAT) / CAST(COUNT(ap.id) AS FLOAT), 3) * 100
as intake_percent
FROM Admissions$ ad
full outer JOIN Applicants$ ap ON ad.applicant_id = ap.id


-- total number of study centers
SELECT COUNT(DISTINCT [study center]) AS study_centers 
FROM StudyCenters$


--------------------------------------------
-- DATA ANALYSIS PHASE USING SQL------------
--------------------------------------------

 --number of applicants BY entry type ==============
SELECT EntryLevelType, COUNT(EntryLevelType) AS total_no_of_applicant
FROM Applicants$
GROUP BY EntryLevelType



-- total  tution fees per year FROM all spec =============
SELECT 
	EntryYear,
	sum(st.amount)  AS total_tution_fee
	FROM FeesTypes$ ft 
 INNER JOIN StudentsTransactions$ st  
on ft.ID = st.FeeID
INNER JOIN Students$ s 
on st.StudentID = s.ID
GROUP BY  EntryYear
ORDER BY EntryYear DESC



-- number of programme per specialization ==========
SELECT 
	[Programme Name], 
	COUNT(sp.id) AS number_of_specialization
FROM Programmes$ pr
INNER JOIN Specializations$ sp
on pr.ID = sp.ProgrammeID
GROUP BY  [Programme Name]
ORDER BY number_of_specialization DESC


-- number of applicants per programme ==========
SELECT 
	[programme Name], 
	COUNT(ad.id) AS number_of_applicant
FROM Admissions$ ad
INNER JOIN Programmes$ pr
on ad.programme_id = pr.ID
GROUP BY  [programme Name]
ORDER BY number_of_applicant DESC


-- number of applicants per study center =============
SELECT TOP 20
		[Study Center],
		COUNT(ap.ID) AS number_of_applicants
FROM Applicants$ ap
INNER JOIN StudyCenters$ sc 
on ap.StudyCenterID = sc.ID
GROUP BY [Study Center]
ORDER BY number_of_applicants DESC


-- number of students per study center ==============
SELECT TOP 20
		[Study Center],
		COUNT(s.ID) AS number_of_students
FROM Students$ s
INNER JOIN StudyCenters$ sc 
on s.StudyCenterID= sc.ID
GROUP BY [Study Center]
ORDER BY number_of_students DESC



-- number of students per programme ================
SELECT 
	[PROGRAMME NAME],
	COUNT(s.ID) AS number_of_students 
FROM Students$ s 
INNER JOIN Programmes$ pr 
on s.ProgrammeID = pr.ID
GROUP BY [PROGRAMME NAME]
ORDER BY number_of_students  DESC


--number of students per specialization (TOP 20) ===============
SELECT TOP 20 Specialization, COUNT(s.ID) AS number_of_students 
FROM Students$ s
INNER JOIN Specializations$ sp 
on s.SpecalizationID = sp.id
GROUP BY Specialization
ORDER BY number_of_students DESC


-- number of applicants per specialization TOP 20 ==============
SELECT TOP 20
		Specialization,
		COUNT(ap.ID) AS number_of_applicants
FROM Applicants$ ap 
INNER JOIN Admissions$ ad
on ap.id = ad.applicant_id
INNER JOIN Specializations$ sp 
on ad.specialization_id = sp.id
GROUP BY specialization 
ORDER BY  number_of_applicants DESC



 -- the total number of applicant per admission status =========
  SELECT [Admission Status], COUNT(DISTINCT applicant_id) AS total_applicants
 FROM Admissions$ ad
 INNER JOIN Applicants$ ap
 ON ad.id = ap.ID
 GROUP BY [Admission Status]
 ORDER BY  total_applicants DESC



 -- semester with the highest course registration ==================
SELECT 
	Semester, 
	COUNT(se.ID) AS totaL_registerd_course
FROM Semesters$ se
INNER JOIN CourseRegistration$ cr 
ON se.ID = cr.SemesterID
GROUP BY Semester


-- total Amount paid BY applicants per specialization ================
SELECT TOP 20
	Specialization,
	sum(amount) AS total_amount
FROM ApplicantionFinancials$ af
INNER JOIN Applicants$ ap
ON af.ApplicantID =ap .ID
INNER JOIN Admissions$ ad
ON ap.ID= ad.applicant_id
INNER JOIN Specializations$ sp
ON ad.specialization_id = sp.id
GROUP BY  Specialization
ORDER BY total_amount DESC


-- total application fees paid BY applicants per fee type ===============
SELECT 
	FeeType, 
	total_amount 
FROM (SELECT DISTINCT FeesTypeID, sum(Amount) AS total_amount
		FROM ApplicantionFinancials$
		GROUP BY FeesTypeID) sub
INNER JOIN FeesTypes$ f
ON sub.FeesTypeID = f.ID


-- total application fees paid BY applicants per payment status ============
SELECT		
	Status,
	sum(Amount) AS total_amount
FROM ApplicantionFinancials$ 
GROUP BY Status
ORDER BY total_amount DESC


-- total application fees paid BY applicants per transaction status =============
SELECT		
	TransactionStatus,
	sum(Amount) AS total_amount
FROM ApplicantionFinancials$ 
where TransactionStatus is not null
GROUP BY TransactionStatus
ORDER BY total_amount DESC


-- total application fees paid BY applicants per program ==============
SELECT		
	(pr.[PROGRAMME NAME]),
	sum(amount) AS total_amount
FROM Programmes$ pr 
INNER JOIN ApplicantionFinancials$ ap 
ON pr.ID = ap.ApplicantProgramID
GROUP BY pr.[PROGRAMME NAME]
ORDER BY total_Amount DESC


-- total application fees paid BY applicants per TOP 20 study centers =============
SELECT TOP 20
	[study center],
	sum(amount) AS total_amount
FROM StudyCenters$ st
INNER JOIN ApplicantionFinancials$ ap 
ON st.ID = ap.ApplicantStudyCenterID
GROUP BY [study center]
ORDER BY total_amount DESC


-- total fees paid per students per fee type ============
SELECT  
	feetype,
	sum(amount) AS total_amount
		 FROM FeesTypes$ ft
INNER JOIN StudentsTransactions$ st 
ON ft.ID = st.FeeID
GROUP BY feetype
ORDER BY total_amount DESC


--  total Amount paid BY students per semester =============
SELECT 
	semester,
	sum(amount) AS total_amount
FROM Semesters$ se
INNER JOIN StudentsTransactions$ st 
ON se.ID = st.SemesterID
GROUP BY semester


--total Amount paid BY students per transaction status ==========
SELECT 
	[status],
	sum(amount) AS total_amount
FROM  StudentsTransactions$ st 
GROUP BY [status]
ORDER BY total_amount DESC


-- total Amount paid BY student per programme 
SELECT 
	[PROGRAMME NAME],
	sum(amount) AS total_amount
FROM Programmes$ pr 
INNER JOIN StudentsTransactions$ st 
ON pr.ID = st.StudentProgramID
GROUP BY [PROGRAMME NAME]
ORDER BY total_amount DESC


-- total Amount paid BY students  per specialization 
SELECT TOP 20
	Specialization,
	sum(amount) AS total_amount
FROM StudentsTransactions$ st
INNER JOIN Students$  s
ON st.StudentID = s.ID
INNER JOIN Specializations$ sp 
ON s.SpecalizationID = sp.id
GROUP BY  Specialization
ORDER BY total_amount DESC


--total Amount paid BY students per study center 
SELECT TOP 20
	[study center],
	sum(amount) AS total_amount
FROM StudyCenters$ sc
INNER JOIN StudentsTransactions$ st
ON sc.ID = st.StudentStudyCenterID
GROUP BY [study center]
ORDER BY total_amount DESC


-- total Amount paid per student payment status 
SELECT
	status,
	sum(amount) AS total_amount
FROM StudentsTransactions$
where [Transaction Status] is not null
GROUP BY status
ORDER BY total_amount DESC


-- total Amount paid per student transaction status
SELECT
	[transaction status],
	sum(amount) AS total_amount
FROM StudentsTransactions$
where [Transaction Status] is not null
GROUP BY [transaction status]
ORDER BY total_amount DESC


-- total number of applicants per payment status 
SELECT status, COUNT(DISTINCT ApplicantID) AS [no. of applicants]
FROM ApplicantionFinancials$
GROUP BY status 


-- total number of applicants per transaction status
SELECT 
		transactionStatus,
		COUNT(ap.ID) AS number_of_applicants
FROM ApplicantionFinancials$ af 
INNER JOIN Applicants$ ap 
ON af.ApplicantID = ap.ID
GROUP BY transactionStatus
ORDER BY number_of_applicants DESC


--total number of students per payment status 
SELECT 
		[status],
		COUNT(s.ID) AS number_of_students
FROM StudentsTransactions$ st
INNER JOIN Students$ s
ON st.StudentID = s.ID
GROUP BY [status]
ORDER BY number_of_students DESC


-- total number of students per transaction status
SELECT 
		[transaction status],
		COUNT(s.ID) AS number_of_students
FROM StudentsTransactions$ st
INNER JOIN Students$ s
ON st.StudentID = s.ID
where [transaction status] is not null
GROUP BY [transaction status]
ORDER BY number_of_students DESC


--total number of students per application status 
SELECT  ApplicationStatus, COUNT(DISTINCT studentID) AS total_registerd_students
FROM CourseRegistration$ cr 
INNER JOIN Applicants$ ap 
ON cr.id = ap.id 
GROUP BY ApplicationStatus


-- student registrations BY registration type 
SELECT RegistrationType, COUNT(RegistrationType) AS total_registration
FROM CourseRegistration$
GROUP BY RegistrationType


-- number of applicants admitted per specialization (TOP 10) 
SELECT Specialization, COUNT(ap.ID) AS number_of_applicant 
FROM Applicants$ ap
INNER JOIN Admissions$ ad
ON ad.applicant_id = ap.ID
INNER JOIN Specializations$ sp 
ON ad.specialization_id = sp.id
GROUP BY Specialization
ORDER BY number_of_applicant DESC



-- number of applicants per year per admission type 
SELECT 
	entry_type, 
	COUNT(ad.ID) AS number_of_applicant
FROM Admissions$ ad
INNER JOIN Applicants$ ap
ON ad.applicant_id = ap.ID 
GROUP BY entry_type


-- number of study center per state 
SELECT  
	st.State, 
	COUNT(sc.ID) AS number_of_studycenter
FROM StudyCenters$ sc
INNER JOIN States$ st
ON sc.StateID = st.ID
GROUP BY st.State
ORDER BY number_of_studycenter DESC


-- number of study centers in the institution (TOP 20) 
SELECT TOP 20
	[Study Center], 
	COUNT(ID) AS number_of_study_centers
FROM StudyCenters$
GROUP BY [Study Center]
ORDER BY number_of_study_centers DESC

-------------------------------------------------
-----------------END-----------------------------
-------------------------------------------------
