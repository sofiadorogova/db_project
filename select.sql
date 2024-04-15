--1. Выбрать пациентов с суммарным покрытием по страховке более 8000:

SELECT patient_id
FROM (
    SELECT patient_id, SUM(coverage_amnt) AS total_coverage
    FROM hospital.insurances
    GROUP BY patient_id
) AS total_coverage
WHERE total_coverage > 8000;

--2. Выбрать даты начала и окончания периодов страхования для пациента с наибольшим покрытием:

SELECT start_date, end_date
FROM hospital.insurances
WHERE patient_id = (
    SELECT patient_id
    FROM (
        SELECT patient_id, SUM(coverage_amnt) AS total_coverage
        FROM hospital.insurances
        GROUP BY patient_id
        ORDER BY total_coverage DESC
        LIMIT 1
    ) AS max_coverage
);

--3. Выбрать все уникальные результаты лабораторных исследований и количество медицинских записей, связанных с каждым результатом:

SELECT lr.result_type, COUNT(mr.record_id) AS record_count
FROM hospital.lab_results AS lr
LEFT JOIN hospital.medical_records AS mr ON lr.result_id = mr.result_id
GROUP BY lr.result_type;

--4. Выбрать список докторов и количество их записей в медицинских картах, отсортированный по убыванию количества записей:

SELECT d.doctor_id, CONCAT(dn.first_name, ' ', dn.last_name) AS doctor_name, COUNT(mr.record_id) AS record_count
FROM hospital.doctors AS d
JOIN hospital.doctor_names AS dn ON d.doctor_id = dn.doctor_id
LEFT JOIN hospital.medical_records AS mr ON d.doctor_id = mr.doctor_id
GROUP BY d.doctor_id, doctor_name
ORDER BY record_count DESC;

-- 5.Выбрать всех пациентов и количество назначений лекарств для каждого пациента, сортировать по кол-ву:

SELECT p.patient_id, COUNT(pr.prescription_id) AS prescription_count
FROM hospital.patients AS p
LEFT JOIN hospital.medical_records AS mr ON p.patient_id = mr.patient_id
LEFT JOIN hospital.prescriptions AS pr ON mr.record_id = pr.med_record_id
GROUP BY p.patient_id
ORDER BY prescription_count DESC;

--6.Выбрать всех врачей и количество пациентов, которые к ним записаны:

SELECT dn.doctor_id, COUNT(ap.patient_id) AS patient_count
FROM hospital.doctor_names AS dn
JOIN hospital.appointments AS ap ON dn.doctor_id = ap.doctor_id
GROUP BY dn.doctor_id
ORDER BY dn.doctor_id;

--7.Выбрать всех пациентов, у которых были лабораторные исследования, и для каждого пациента выбрать самое раннее и самое позднее исследование:

SELECT p.patient_id, MIN(mr.date) AS earliest_lab_date, MAX(mr.date) AS latest_lab_date
FROM hospital.patients AS p
JOIN hospital.medical_records AS mr ON p.patient_id = mr.patient_id
WHERE mr.result_id IS NOT NULL
GROUP BY p.patient_id;

--8.Выбрать всех пациентов и количество различных лекарств, которые им назначались:

SELECT mr.patient_id, COUNT(DISTINCT pr.medication) AS unique_med_count
FROM hospital.medical_records AS mr
JOIN hospital.prescriptions AS pr ON mr.record_id = pr.med_record_id
GROUP BY mr.patient_id;

--9. Выбрать всех пациентов и их соответствующие назначения лекарств:

SELECT 
    p.patient_id, 
    p.birth_date, 
    p.gender, 
    (
        SELECT COUNT(*) 
        FROM hospital.prescriptions AS pr 
        JOIN hospital.medical_records AS mr ON pr.med_record_id = mr.record_id 
        WHERE mr.patient_id = p.patient_id
    ) AS prescription_count
FROM hospital.patients AS p;

--10. Выбрать всех пациентов с их результатами лабораторных исследований, сортировать по индексу пациента:

SELECT 
    p.patient_id, 
    p.birth_date, 
    p.gender, 
    (
        SELECT result_type 
        FROM hospital.lab_results AS lr 
        WHERE lr.result_id = mr.result_id
    ) AS lab_result
FROM hospital.patients AS p
JOIN hospital.medical_records AS mr ON p.patient_id = mr.patient_id
ORDER BY p.patient_id;
    
