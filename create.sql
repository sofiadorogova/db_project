CREATE SCHEMA hospital

-- Создание таблицы "doctors"
CREATE TABLE hospital.doctors (
    doctor_id SERIAL PRIMARY KEY,
    specialization VARCHAR(100) NOT NULL,
    license VARCHAR(50) UNIQUE NOT NULL,
    schedule VARCHAR(100) NOT NULL
);

-- Создание таблицы "doctor_names"
CREATE TABLE hospital.doctor_names (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES hospital.doctors(doctor_id)
);

-- Создание таблицы "patients"
CREATE TABLE hospital.patients (
    patient_id SERIAL PRIMARY KEY,
    birth_date DATE NOT NULL,
    gender VARCHAR(10) NOT NULL,
    contact_info VARCHAR(255) NOT NULL
);

-- Создание таблицы "patient_names"
CREATE TABLE hospital.patient_names (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    FOREIGN KEY (patient_id) REFERENCES hospital.patients(patient_id)
);

-- Создание таблицы "diagnoses"
CREATE TABLE hospital.diagnoses (
    diagnose_code SERIAL PRIMARY KEY,
    diagnose_desc VARCHAR(255) NOT NULL
);

-- Создание таблицы "lab_results"
CREATE TABLE hospital.lab_results (
    result_id SERIAL PRIMARY KEY,
    result_type VARCHAR(100) NOT NULL,
    UNIQUE (result_type)
);

-- Создание таблицы "medical_records"
CREATE TABLE hospital.medical_records (
    record_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    result_id INT NOT NULL,
    diagnose_code INT NOT NULL,
    UNIQUE (patient_id, doctor_id, date),
    FOREIGN KEY (patient_id) REFERENCES hospital.patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES hospital.doctors(doctor_id),
    FOREIGN KEY (result_id) REFERENCES hospital.lab_results(result_id),
    FOREIGN KEY (diagnose_code) REFERENCES hospital.diagnoses(diagnose_code)
);

-- Создание таблицы "insurances"
CREATE TABLE hospital.insurances (
    policy_id SERIAL PRIMARY KEY,
    patient_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    coverage_amnt DECIMAL(10, 2),
    FOREIGN KEY (patient_id) REFERENCES hospital.patients(patient_id),
    CHECK (coverage_amnt >= 0)
);

-- Создание таблицы "history_insurances"
CREATE TABLE hospital.history_insurances (
    policy_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    coverage_amnt DECIMAL(10, 2),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    PRIMARY KEY (valid_from, valid_to, policy_id),
    FOREIGN KEY (policy_id) REFERENCES hospital.insurances(policy_id),
    CHECK (valid_from <= valid_to),
    CHECK (coverage_amnt >= 0)
);

-- Создание таблицы "price_list"
CREATE TABLE hospital.price_list (
    service_id SERIAL PRIMARY KEY,
    insurance_bill DECIMAL(10, 2) DEFAULT 0 CHECK (insurance_bill >= 0),
    another_bill DECIMAL(10, 2) DEFAULT 0 CHECK (another_bill >= 0)
);

-- Создание таблицы "invoice"
CREATE TABLE hospital.invoice (
    invoice_id SERIAL,
    patient_id INT NOT NULL,
    service_id INT NOT NULL,
    pay_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(50),
    valid_from DATE NOT NULL,
    valid_to DATE NOT NULL,
    PRIMARY KEY (invoice_id, valid_from, valid_to),
    FOREIGN KEY (patient_id) REFERENCES hospital.patients(patient_id),
    FOREIGN KEY (service_id) REFERENCES hospital.price_list(service_id),
    CHECK (valid_from <= valid_to)
);

-- Создание таблицы "appointments"
CREATE TABLE hospital.appointments (
    appointment_id SERIAL PRIMARY KEY,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES hospital.doctors(doctor_id),
    FOREIGN KEY (patient_id) REFERENCES hospital.patients(patient_id)
);

-- Создание таблицы "prescriptions"
CREATE TABLE hospital.prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    med_record_id INT NOT NULL,
    medication VARCHAR(100) NOT NULL,
    dosage VARCHAR(100) NOT NULL,
    duration INT NOT NULL,
    FOREIGN KEY (med_record_id) REFERENCES hospital.medical_records(record_id)
);

