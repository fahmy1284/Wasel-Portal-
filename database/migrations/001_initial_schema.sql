-- =====================================================
-- Yemen E-Government System (Wasel) Database Schema
-- Initial Migration - Complete Database Structure
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- =====================================================
-- ENUMS AND CUSTOM TYPES
-- =====================================================

-- User roles enum
CREATE TYPE user_role AS ENUM (
    'citizen',
    'employee', 
    'department_admin',
    'ministry_admin',
    'admin',
    'super_admin'
);

-- Gender enum
CREATE TYPE gender_type AS ENUM ('male', 'female');

-- Marital status enum
CREATE TYPE marital_status_type AS ENUM (
    'single',
    'married', 
    'divorced',
    'widowed'
);

-- Transaction status enum
CREATE TYPE transaction_status AS ENUM (
    'pending',
    'in_progress',
    'under_review',
    'approved',
    'rejected',
    'completed',
    'cancelled'
);

-- Payment status enum
CREATE TYPE payment_status AS ENUM (
    'pending',
    'processing',
    'completed',
    'failed',
    'refunded',
    'cancelled'
);

-- Priority level enum
CREATE TYPE priority_level AS ENUM (
    'low',
    'normal',
    'high',
    'urgent',
    'critical'
);

-- Notification type enum
CREATE TYPE notification_type AS ENUM (
    'transaction_update',
    'payment_reminder',
    'appointment_reminder',
    'document_ready',
    'system_maintenance',
    'security_alert'
);

-- =====================================================
-- CORE TABLES
-- =====================================================

-- Users table (extends Supabase auth.users)
CREATE TABLE users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    national_id VARCHAR(10) UNIQUE,
    phone VARCHAR(15),
    address TEXT,
    date_of_birth DATE,
    gender gender_type,
    role user_role NOT NULL DEFAULT 'citizen',
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_verified BOOLEAN NOT NULL DEFAULT false,
    profile_image_url TEXT,
    last_login_at TIMESTAMPTZ,
    
    -- Additional profile information
    occupation VARCHAR(255),
    marital_status marital_status_type,
    nationality VARCHAR(100) DEFAULT 'يمني',
    emergency_contact_name VARCHAR(255),
    emergency_contact_phone VARCHAR(15),
    
    -- Preferences
    language VARCHAR(10) DEFAULT 'ar',
    notification_preferences JSONB DEFAULT '{}',
    privacy_settings JSONB DEFAULT '{}',
    
    -- Security
    two_factor_enabled BOOLEAN NOT NULL DEFAULT false,
    biometric_enabled BOOLEAN NOT NULL DEFAULT false,
    password_changed_at TIMESTAMPTZ,
    failed_login_attempts INTEGER NOT NULL DEFAULT 0,
    locked_until TIMESTAMPTZ,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Employees table (for government employees)
CREATE TABLE employees (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    employee_number VARCHAR(20) UNIQUE NOT NULL,
    department_id UUID,
    ministry_id UUID,
    position VARCHAR(255),
    hire_date DATE,
    salary DECIMAL(10,2),
    supervisor_id UUID REFERENCES employees(id),
    
    -- Work information
    work_location VARCHAR(255),
    work_phone VARCHAR(15),
    work_email VARCHAR(255),
    office_number VARCHAR(50),
    
    -- Status
    employment_status VARCHAR(50) DEFAULT 'active',
    termination_date DATE,
    termination_reason TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Departments table
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    ministry_id UUID,
    parent_department_id UUID REFERENCES departments(id),
    head_employee_id UUID REFERENCES employees(id),
    
    -- Contact information
    phone VARCHAR(15),
    email VARCHAR(255),
    address TEXT,
    
    -- Settings
    is_active BOOLEAN NOT NULL DEFAULT true,
    service_hours JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Ministries table
CREATE TABLE ministries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    minister_name VARCHAR(255),
    
    -- Contact information
    phone VARCHAR(15),
    email VARCHAR(255),
    address TEXT,
    website VARCHAR(255),
    
    -- Settings
    is_active BOOLEAN NOT NULL DEFAULT true,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- SERVICES AND CATEGORIES
-- =====================================================

-- Service categories table
CREATE TABLE service_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    icon VARCHAR(100),
    color VARCHAR(7),
    parent_category_id UUID REFERENCES service_categories(id),
    sort_order INTEGER DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT true,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Services table
CREATE TABLE services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    category_id UUID REFERENCES service_categories(id),
    ministry_id UUID REFERENCES ministries(id),
    department_id UUID REFERENCES departments(id),
    
    -- Service details
    service_code VARCHAR(20) UNIQUE,
    icon VARCHAR(100),
    color VARCHAR(7),
    estimated_duration INTEGER, -- in days
    fee DECIMAL(10,2) DEFAULT 0,
    
    -- Requirements and process
    requirements JSONB DEFAULT '[]',
    process_steps JSONB DEFAULT '[]',
    required_documents JSONB DEFAULT '[]',
    
    -- Settings
    is_active BOOLEAN NOT NULL DEFAULT true,
    requires_appointment BOOLEAN DEFAULT false,
    is_online_only BOOLEAN DEFAULT false,
    priority_level priority_level DEFAULT 'normal',
    
    -- Statistics
    request_count INTEGER DEFAULT 0,
    average_processing_time INTEGER DEFAULT 0,
    satisfaction_rating DECIMAL(3,2) DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Service requirements table
CREATE TABLE service_requirements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    is_mandatory BOOLEAN NOT NULL DEFAULT true,
    document_type VARCHAR(100),
    order_index INTEGER DEFAULT 0,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Service steps table
CREATE TABLE service_steps (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    service_id UUID NOT NULL REFERENCES services(id) ON DELETE CASCADE,
    step_number INTEGER NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    estimated_duration INTEGER, -- in hours
    responsible_role user_role,
    is_automated BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- TRANSACTIONS AND REQUESTS
-- =====================================================

-- Service transactions table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_number VARCHAR(50) UNIQUE NOT NULL,
    service_id UUID NOT NULL REFERENCES services(id),
    user_id UUID NOT NULL REFERENCES users(id),
    
    -- Transaction details
    status transaction_status NOT NULL DEFAULT 'pending',
    priority_level priority_level DEFAULT 'normal',
    form_data JSONB DEFAULT '{}',
    notes TEXT,
    
    -- Assignment
    assigned_to UUID REFERENCES employees(id),
    assigned_at TIMESTAMPTZ,
    
    -- Timing
    submitted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    started_at TIMESTAMPTZ,
    completed_at TIMESTAMPTZ,
    due_date TIMESTAMPTZ,
    
    -- Payment
    fee_amount DECIMAL(10,2) DEFAULT 0,
    is_paid BOOLEAN DEFAULT false,
    payment_id UUID,
    
    -- Tracking
    current_step INTEGER DEFAULT 1,
    total_steps INTEGER DEFAULT 1,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Transaction status history table
CREATE TABLE transaction_status_history (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    status transaction_status NOT NULL,
    notes TEXT,
    changed_by UUID REFERENCES users(id),
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Transaction documents table
CREATE TABLE transaction_documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions(id) ON DELETE CASCADE,
    document_name VARCHAR(255) NOT NULL,
    document_type VARCHAR(100),
    file_path TEXT NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    uploaded_by UUID REFERENCES users(id),
    
    -- Document details
    is_required BOOLEAN DEFAULT false,
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES employees(id),
    verified_at TIMESTAMPTZ,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- APPOINTMENTS
-- =====================================================

-- Appointments table
CREATE TABLE appointments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID REFERENCES transactions(id),
    user_id UUID NOT NULL REFERENCES users(id),
    service_id UUID NOT NULL REFERENCES services(id),
    employee_id UUID REFERENCES employees(id),
    department_id UUID REFERENCES departments(id),
    
    -- Appointment details
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    duration_minutes INTEGER DEFAULT 30,
    status VARCHAR(50) DEFAULT 'scheduled',
    
    -- Location
    location VARCHAR(255),
    room_number VARCHAR(50),
    
    -- Notes
    notes TEXT,
    cancellation_reason TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- PAYMENTS
-- =====================================================

-- Payment methods table
CREATE TABLE payment_methods (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    type VARCHAR(50) NOT NULL, -- 'bank_transfer', 'credit_card', 'mobile_wallet', etc.
    provider VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT true,
    configuration JSONB DEFAULT '{}',
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Payments table
CREATE TABLE payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    transaction_id UUID NOT NULL REFERENCES transactions(id),
    user_id UUID NOT NULL REFERENCES users(id),
    payment_method_id UUID REFERENCES payment_methods(id),
    
    -- Payment details
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'YER',
    status payment_status NOT NULL DEFAULT 'pending',
    
    -- External payment details
    external_payment_id VARCHAR(255),
    gateway_response JSONB DEFAULT '{}',
    
    -- Timing
    paid_at TIMESTAMPTZ,
    expires_at TIMESTAMPTZ,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- NOTIFICATIONS
-- =====================================================

-- Notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id),
    type notification_type NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    
    -- Related entities
    transaction_id UUID REFERENCES transactions(id),
    appointment_id UUID REFERENCES appointments(id),
    payment_id UUID REFERENCES payments(id),
    
    -- Status
    is_read BOOLEAN NOT NULL DEFAULT false,
    read_at TIMESTAMPTZ,
    
    -- Delivery
    sent_via JSONB DEFAULT '{}', -- email, sms, push, etc.
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- SYSTEM TABLES
-- =====================================================

-- System settings table
CREATE TABLE system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(255) UNIQUE NOT NULL,
    value JSONB NOT NULL,
    description TEXT,
    category VARCHAR(100),
    is_public BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Activity logs table
CREATE TABLE activity_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(255) NOT NULL,
    entity_type VARCHAR(100),
    entity_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Audit logs table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    table_name VARCHAR(100) NOT NULL,
    operation VARCHAR(10) NOT NULL, -- INSERT, UPDATE, DELETE
    record_id UUID NOT NULL,
    old_data JSONB,
    new_data JSONB,
    changed_by UUID REFERENCES users(id),
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- ROLES AND PERMISSIONS
-- =====================================================

-- Roles table
CREATE TABLE roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    is_system_role BOOLEAN DEFAULT false,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Permissions table
CREATE TABLE permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) UNIQUE NOT NULL,
    display_name VARCHAR(255) NOT NULL,
    description TEXT,
    resource VARCHAR(100) NOT NULL,
    action VARCHAR(100) NOT NULL,
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Role permissions table
CREATE TABLE role_permissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    permission_id UUID NOT NULL REFERENCES permissions(id) ON DELETE CASCADE,
    
    UNIQUE(role_id, permission_id),
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- User roles table
CREATE TABLE user_roles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role_id UUID NOT NULL REFERENCES roles(id) ON DELETE CASCADE,
    
    UNIQUE(user_id, role_id),
    
    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Users indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_national_id ON users(national_id);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_is_active ON users(is_active);
CREATE INDEX idx_users_created_at ON users(created_at);

-- Employees indexes
CREATE INDEX idx_employees_user_id ON employees(user_id);
CREATE INDEX idx_employees_department_id ON employees(department_id);
CREATE INDEX idx_employees_ministry_id ON employees(ministry_id);
CREATE INDEX idx_employees_employee_number ON employees(employee_number);

-- Services indexes
CREATE INDEX idx_services_category_id ON services(category_id);
CREATE INDEX idx_services_ministry_id ON services(ministry_id);
CREATE INDEX idx_services_department_id ON services(department_id);
CREATE INDEX idx_services_is_active ON services(is_active);
CREATE INDEX idx_services_service_code ON services(service_code);

-- Transactions indexes
CREATE INDEX idx_transactions_user_id ON transactions(user_id);
CREATE INDEX idx_transactions_service_id ON transactions(service_id);
CREATE INDEX idx_transactions_status ON transactions(status);
CREATE INDEX idx_transactions_assigned_to ON transactions(assigned_to);
CREATE INDEX idx_transactions_transaction_number ON transactions(transaction_number);
CREATE INDEX idx_transactions_created_at ON transactions(created_at);
CREATE INDEX idx_transactions_submitted_at ON transactions(submitted_at);

-- Appointments indexes
CREATE INDEX idx_appointments_user_id ON appointments(user_id);
CREATE INDEX idx_appointments_service_id ON appointments(service_id);
CREATE INDEX idx_appointments_employee_id ON appointments(employee_id);
CREATE INDEX idx_appointments_appointment_date ON appointments(appointment_date);
CREATE INDEX idx_appointments_status ON appointments(status);

-- Payments indexes
CREATE INDEX idx_payments_transaction_id ON payments(transaction_id);
CREATE INDEX idx_payments_user_id ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);
CREATE INDEX idx_payments_created_at ON payments(created_at);

-- Notifications indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);

-- Activity logs indexes
CREATE INDEX idx_activity_logs_user_id ON activity_logs(user_id);
CREATE INDEX idx_activity_logs_action ON activity_logs(action);
CREATE INDEX idx_activity_logs_entity_type ON activity_logs(entity_type);
CREATE INDEX idx_activity_logs_created_at ON activity_logs(created_at);

-- Full-text search indexes
CREATE INDEX idx_services_search ON services USING gin(to_tsvector('arabic', name || ' ' || COALESCE(description, '')));
CREATE INDEX idx_users_search ON users USING gin(to_tsvector('arabic', full_name || ' ' || email));

-- =====================================================
-- TRIGGERS AND FUNCTIONS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to all relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON employees FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_ministries_updated_at BEFORE UPDATE ON ministries FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_categories_updated_at BEFORE UPDATE ON service_categories FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_requirements_updated_at BEFORE UPDATE ON service_requirements FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_service_steps_updated_at BEFORE UPDATE ON service_steps FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transactions_updated_at BEFORE UPDATE ON transactions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_transaction_documents_updated_at BEFORE UPDATE ON transaction_documents FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON appointments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payment_methods_updated_at BEFORE UPDATE ON payment_methods FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_notifications_updated_at BEFORE UPDATE ON notifications FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_roles_updated_at BEFORE UPDATE ON roles FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_permissions_updated_at BEFORE UPDATE ON permissions FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate transaction number
CREATE OR REPLACE FUNCTION generate_transaction_number()
RETURNS TEXT AS $$
DECLARE
    year_part TEXT;
    sequence_part TEXT;
    result TEXT;
BEGIN
    year_part := EXTRACT(YEAR FROM NOW())::TEXT;
    
    SELECT LPAD((COUNT(*) + 1)::TEXT, 6, '0') INTO sequence_part
    FROM transactions 
    WHERE EXTRACT(YEAR FROM created_at) = EXTRACT(YEAR FROM NOW());
    
    result := 'TXN' || year_part || sequence_part;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-generate transaction number
CREATE OR REPLACE FUNCTION set_transaction_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.transaction_number IS NULL OR NEW.transaction_number = '' THEN
        NEW.transaction_number := generate_transaction_number();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_transaction_number_trigger
    BEFORE INSERT ON transactions
    FOR EACH ROW
    EXECUTE FUNCTION set_transaction_number();

-- Audit trigger function
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, OLD.id, row_to_json(OLD), NULL);
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (table_name, operation, record_id, old_data, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, NEW.id, row_to_json(OLD), row_to_json(NEW), NULL);
        RETURN NEW;
    ELSIF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (table_name, operation, record_id, new_data, changed_by)
        VALUES (TG_TABLE_NAME, TG_OP, NEW.id, row_to_json(NEW), NULL);
        RETURN NEW;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Apply audit triggers to important tables
CREATE TRIGGER audit_users_trigger AFTER INSERT OR UPDATE OR DELETE ON users FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
CREATE TRIGGER audit_transactions_trigger AFTER INSERT OR UPDATE OR DELETE ON transactions FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();
CREATE TRIGGER audit_payments_trigger AFTER INSERT OR UPDATE OR DELETE ON payments FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all user-facing tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE transaction_documents ENABLE ROW LEVEL SECURITY;

-- Users can only see their own data
CREATE POLICY users_own_data ON users FOR ALL USING (auth.uid() = id);

-- Transactions policies
CREATE POLICY transactions_own_data ON transactions FOR ALL USING (
    auth.uid() = user_id OR 
    EXISTS (
        SELECT 1 FROM users 
        WHERE users.id = auth.uid() 
        AND users.role IN ('employee', 'department_admin', 'ministry_admin', 'admin', 'super_admin')
    )
);

-- Appointments policies
CREATE POLICY appointments_own_data ON appointments FOR ALL USING (
    auth.uid() = user_id OR 
    EXISTS (
        SELECT 1 FROM users 
        WHERE users.id = auth.uid() 
        AND users.role IN ('employee', 'department_admin', 'ministry_admin', 'admin', 'super_admin')
    )
);

-- Payments policies
CREATE POLICY payments_own_data ON payments FOR ALL USING (
    auth.uid() = user_id OR 
    EXISTS (
        SELECT 1 FROM users 
        WHERE users.id = auth.uid() 
        AND users.role IN ('employee', 'department_admin', 'ministry_admin', 'admin', 'super_admin')
    )
);

-- Notifications policies
CREATE POLICY notifications_own_data ON notifications FOR ALL USING (auth.uid() = user_id);

-- Transaction documents policies
CREATE POLICY transaction_documents_access ON transaction_documents FOR ALL USING (
    EXISTS (
        SELECT 1 FROM transactions 
        WHERE transactions.id = transaction_documents.transaction_id 
        AND (transactions.user_id = auth.uid() OR 
             EXISTS (
                 SELECT 1 FROM users 
                 WHERE users.id = auth.uid() 
                 AND users.role IN ('employee', 'department_admin', 'ministry_admin', 'admin', 'super_admin')
             ))
    )
);

-- =====================================================
-- VIEWS FOR COMMON QUERIES
-- =====================================================

-- User profile view
CREATE VIEW user_profiles AS
SELECT 
    u.id,
    u.email,
    u.full_name,
    u.national_id,
    u.phone,
    u.address,
    u.date_of_birth,
    u.gender,
    u.role,
    u.is_active,
    u.is_verified,
    u.profile_image_url,
    u.last_login_at,
    u.occupation,
    u.marital_status,
    u.nationality,
    u.language,
    u.two_factor_enabled,
    u.biometric_enabled,
    u.created_at,
    u.updated_at,
    CASE 
        WHEN u.date_of_birth IS NOT NULL THEN 
            EXTRACT(YEAR FROM AGE(u.date_of_birth))
        ELSE NULL 
    END as age
FROM users u;

-- Transaction details view
CREATE VIEW transaction_details AS
SELECT 
    t.id,
    t.transaction_number,
    t.status,
    t.priority_level,
    t.submitted_at,
    t.started_at,
    t.completed_at,
    t.due_date,
    t.fee_amount,
    t.is_paid,
    t.current_step,
    t.total_steps,
    
    -- Service details
    s.name as service_name,
    s.service_code,
    s.estimated_duration,
    
    -- User details
    u.full_name as user_name,
    u.email as user_email,
    u.phone as user_phone,
    
    -- Employee details
    eu.full_name as assigned_employee_name,
    
    -- Category details
    sc.name as category_name,
    
    -- Department details
    d.name as department_name,
    
    -- Ministry details
    m.name as ministry_name
    
FROM transactions t
JOIN services s ON t.service_id = s.id
JOIN users u ON t.user_id = u.id
LEFT JOIN users eu ON t.assigned_to = eu.id
LEFT JOIN service_categories sc ON s.category_id = sc.id
LEFT JOIN departments d ON s.department_id = d.id
LEFT JOIN ministries m ON s.ministry_id = m.id;

-- Service statistics view
CREATE VIEW service_statistics AS
SELECT 
    s.id,
    s.name,
    s.service_code,
    s.category_id,
    sc.name as category_name,
    s.ministry_id,
    m.name as ministry_name,
    s.department_id,
    d.name as department_name,
    
    -- Statistics
    COUNT(t.id) as total_requests,
    COUNT(CASE WHEN t.status = 'completed' THEN 1 END) as completed_requests,
    COUNT(CASE WHEN t.status = 'pending' THEN 1 END) as pending_requests,
    COUNT(CASE WHEN t.status = 'in_progress' THEN 1 END) as in_progress_requests,
    COUNT(CASE WHEN t.status = 'rejected' THEN 1 END) as rejected_requests,
    
    -- Averages
    AVG(CASE 
        WHEN t.completed_at IS NOT NULL AND t.submitted_at IS NOT NULL 
        THEN EXTRACT(EPOCH FROM (t.completed_at - t.submitted_at))/86400 
    END) as avg_processing_days,
    
    SUM(t.fee_amount) as total_revenue,
    
    s.created_at,
    s.updated_at
    
FROM services s
LEFT JOIN transactions t ON s.id = t.service_id
LEFT JOIN service_categories sc ON s.category_id = sc.id
LEFT JOIN ministries m ON s.ministry_id = m.id
LEFT JOIN departments d ON s.department_id = d.id
GROUP BY s.id, s.name, s.service_code, s.category_id, sc.name, 
         s.ministry_id, m.name, s.department_id, d.name, s.created_at, s.updated_at;

-- =====================================================
-- INITIAL DATA SETUP
-- =====================================================

-- Insert default system settings
INSERT INTO system_settings (key, value, description, category, is_public) VALUES
('app_name', '"واصل"', 'اسم التطبيق', 'general', true),
('app_version', '"1.0.0"', 'إصدار التطبيق', 'general', true),
('maintenance_mode', 'false', 'وضع الصيانة', 'system', false),
('max_file_size', '10485760', 'الحد الأقصى لحجم الملف (بايت)', 'uploads', false),
('allowed_file_types', '["pdf", "jpg", "jpeg", "png", "doc", "docx"]', 'أنواع الملفات المسموحة', 'uploads', false),
('session_timeout', '3600', 'انتهاء صلاحية الجلسة (ثانية)', 'security', false),
('max_login_attempts', '5', 'الحد الأقصى لمحاولات تسجيل الدخول', 'security', false),
('password_min_length', '8', 'الحد الأدنى لطول كلمة المرور', 'security', false);

-- Insert default roles
INSERT INTO roles (name, display_name, description, is_system_role) VALUES
('citizen', 'مواطن', 'مواطن عادي يستخدم الخدمات', true),
('employee', 'موظف', 'موظف حكومي', true),
('department_admin', 'مدير قسم', 'مدير قسم حكومي', true),
('ministry_admin', 'مدير وزارة', 'مدير وزارة', true),
('admin', 'مدير', 'مدير النظام', true),
('super_admin', 'مدير عام', 'مدير عام للنظام', true);

-- Insert default permissions
INSERT INTO permissions (name, display_name, description, resource, action) VALUES
('view_own_profile', 'عرض الملف الشخصي', 'عرض الملف الشخصي الخاص', 'profile', 'view'),
('edit_own_profile', 'تعديل الملف الشخصي', 'تعديل الملف الشخصي الخاص', 'profile', 'edit'),
('view_services', 'عرض الخدمات', 'عرض قائمة الخدمات المتاحة', 'services', 'view'),
('create_transaction', 'إنشاء معاملة', 'إنشاء معاملة جديدة', 'transactions', 'create'),
('view_own_transactions', 'عرض المعاملات الشخصية', 'عرض المعاملات الشخصية', 'transactions', 'view'),
('view_all_transactions', 'عرض جميع المعاملات', 'عرض جميع المعاملات', 'transactions', 'view_all'),
('process_transactions', 'معالجة المعاملات', 'معالجة ومراجعة المعاملات', 'transactions', 'process'),
('manage_users', 'إدارة المستخدمين', 'إدارة حسابات المستخدمين', 'users', 'manage'),
('manage_services', 'إدارة الخدمات', 'إدارة الخدمات والفئات', 'services', 'manage'),
('view_reports', 'عرض التقارير', 'عرض التقارير والإحصائيات', 'reports', 'view'),
('system_admin', 'إدارة النظام', 'إدارة إعدادات النظام', 'system', 'admin');

-- Assign permissions to roles
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.name = 'citizen' AND p.name IN (
    'view_own_profile', 'edit_own_profile', 'view_services', 
    'create_transaction', 'view_own_transactions'
);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.name = 'employee' AND p.name IN (
    'view_own_profile', 'edit_own_profile', 'view_services', 
    'view_all_transactions', 'process_transactions'
);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.name = 'department_admin' AND p.name IN (
    'view_own_profile', 'edit_own_profile', 'view_services', 
    'view_all_transactions', 'process_transactions', 'manage_services', 'view_reports'
);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.name = 'ministry_admin' AND p.name IN (
    'view_own_profile', 'edit_own_profile', 'view_services', 
    'view_all_transactions', 'process_transactions', 'manage_services', 
    'manage_users', 'view_reports'
);

INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id FROM roles r, permissions p 
WHERE r.name IN ('admin', 'super_admin');

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================

DO $$
BEGIN
    RAISE NOTICE 'Yemen E-Government System (Wasel) database schema created successfully!';
    RAISE NOTICE 'Total tables created: %', (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public');
    RAISE NOTICE 'Total indexes created: %', (SELECT COUNT(*) FROM pg_indexes WHERE schemaname = 'public');
    RAISE NOTICE 'Total functions created: %', (SELECT COUNT(*) FROM information_schema.routines WHERE routine_schema = 'public');
END $$;