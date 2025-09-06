-- =====================================================
-- Wasel Portal - Complete Database Schema for Supabase
-- Yemen Government Services Portal
-- =====================================================

-- Enable necessary extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- =====================================================
-- CUSTOM TYPES
-- =====================================================

-- User role types
CREATE TYPE user_role AS ENUM (
    'super_admin',
    'admin', 
    'ministry_admin',
    'department_admin',
    'employee',
    'citizen'
);

-- Service status types
CREATE TYPE service_status AS ENUM (
    'active',
    'inactive',
    'maintenance',
    'deprecated'
);

-- Request status types
CREATE TYPE request_status AS ENUM (
    'draft',
    'submitted',
    'under_review',
    'approved',
    'rejected',
    'completed',
    'cancelled'
);

-- Payment status types
CREATE TYPE payment_status AS ENUM (
    'pending',
    'processing',
    'completed',
    'failed',
    'refunded'
);

-- Document types
CREATE TYPE document_type AS ENUM (
    'national_id',
    'passport',
    'birth_certificate',
    'marriage_certificate',
    'divorce_certificate',
    'death_certificate',
    'business_license',
    'tax_certificate',
    'property_deed',
    'driving_license',
    'vehicle_registration',
    'medical_certificate',
    'education_certificate',
    'employment_certificate',
    'other'
);

-- Notification types
CREATE TYPE notification_type AS ENUM (
    'info',
    'warning',
    'error',
    'success',
    'reminder'
);

-- =====================================================
-- CORE TABLES
-- =====================================================

-- Users table (extends Supabase auth.users)
CREATE TABLE public.users (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    national_id VARCHAR(20) UNIQUE,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20),
    full_name VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(10),
    address TEXT,
    city VARCHAR(100),
    governorate VARCHAR(100),
    role user_role DEFAULT 'citizen',
    is_active BOOLEAN DEFAULT true,
    email_verified BOOLEAN DEFAULT false,
    phone_verified BOOLEAN DEFAULT false,
    profile_image_url TEXT,
    last_login_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Ministries and government entities
CREATE TABLE public.ministries (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    logo_url TEXT,
    website_url TEXT,
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    address TEXT,
    minister_name VARCHAR(255),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Departments within ministries
CREATE TABLE public.departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ministry_id UUID REFERENCES ministries(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    head_name VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Government services
CREATE TABLE public.services (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ministry_id UUID REFERENCES ministries(id),
    department_id UUID REFERENCES departments(id),
    name VARCHAR(255) NOT NULL,
    name_en VARCHAR(255),
    description TEXT,
    description_en TEXT,
    category VARCHAR(100),
    subcategory VARCHAR(100),
    service_code VARCHAR(50) UNIQUE,
    fee_amount DECIMAL(10,2) DEFAULT 0,
    processing_time_days INTEGER DEFAULT 1,
    required_documents TEXT[], -- Array of required document types
    status service_status DEFAULT 'active',
    icon_url TEXT,
    instructions TEXT,
    terms_and_conditions TEXT,
    is_online BOOLEAN DEFAULT true,
    priority INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Service requests
CREATE TABLE public.service_requests (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_number VARCHAR(50) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    service_id UUID REFERENCES services(id),
    status request_status DEFAULT 'draft',
    form_data JSONB,
    submitted_at TIMESTAMP WITH TIME ZONE,
    reviewed_at TIMESTAMP WITH TIME ZONE,
    completed_at TIMESTAMP WITH TIME ZONE,
    reviewer_id UUID REFERENCES users(id),
    reviewer_notes TEXT,
    rejection_reason TEXT,
    priority INTEGER DEFAULT 0,
    estimated_completion_date DATE,
    actual_completion_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Documents uploaded by users
CREATE TABLE public.documents (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    request_id UUID REFERENCES service_requests(id) ON DELETE CASCADE,
    document_type document_type,
    file_name VARCHAR(255) NOT NULL,
    file_path TEXT NOT NULL,
    file_size INTEGER,
    mime_type VARCHAR(100),
    is_verified BOOLEAN DEFAULT false,
    verified_by UUID REFERENCES users(id),
    verified_at TIMESTAMP WITH TIME ZONE,
    expiry_date DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Payments
CREATE TABLE public.payments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    request_id UUID REFERENCES service_requests(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'YER',
    payment_method VARCHAR(50),
    transaction_id VARCHAR(255),
    gateway_response JSONB,
    status payment_status DEFAULT 'pending',
    paid_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Notifications
CREATE TABLE public.notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type notification_type DEFAULT 'info',
    is_read BOOLEAN DEFAULT false,
    action_url TEXT,
    metadata JSONB,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- System settings
CREATE TABLE public.system_settings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    key VARCHAR(255) UNIQUE NOT NULL,
    value TEXT,
    description TEXT,
    is_public BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Audit logs
CREATE TABLE public.audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id UUID,
    old_values JSONB,
    new_values JSONB,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User sessions for tracking
CREATE TABLE public.user_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE,
    device_info JSONB,
    ip_address INET,
    location JSONB,
    is_active BOOLEAN DEFAULT true,
    expires_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- FAQ and help content
CREATE TABLE public.faqs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    question TEXT NOT NULL,
    answer TEXT NOT NULL,
    category VARCHAR(100),
    service_id UUID REFERENCES services(id),
    is_active BOOLEAN DEFAULT true,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- News and announcements
CREATE TABLE public.news (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    summary TEXT,
    image_url TEXT,
    author_id UUID REFERENCES users(id),
    is_published BOOLEAN DEFAULT false,
    published_at TIMESTAMP WITH TIME ZONE,
    expires_at TIMESTAMP WITH TIME ZONE,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- INDEXES FOR PERFORMANCE
-- =====================================================

-- Users indexes
CREATE INDEX idx_users_national_id ON users(national_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_active ON users(is_active);

-- Services indexes
CREATE INDEX idx_services_ministry ON services(ministry_id);
CREATE INDEX idx_services_department ON services(department_id);
CREATE INDEX idx_services_status ON services(status);
CREATE INDEX idx_services_category ON services(category);
CREATE INDEX idx_services_code ON services(service_code);

-- Service requests indexes
CREATE INDEX idx_requests_user ON service_requests(user_id);
CREATE INDEX idx_requests_service ON service_requests(service_id);
CREATE INDEX idx_requests_status ON service_requests(status);
CREATE INDEX idx_requests_number ON service_requests(request_number);
CREATE INDEX idx_requests_submitted ON service_requests(submitted_at);

-- Documents indexes
CREATE INDEX idx_documents_user ON documents(user_id);
CREATE INDEX idx_documents_request ON documents(request_id);
CREATE INDEX idx_documents_type ON documents(document_type);

-- Payments indexes
CREATE INDEX idx_payments_request ON payments(request_id);
CREATE INDEX idx_payments_user ON payments(user_id);
CREATE INDEX idx_payments_status ON payments(status);

-- Notifications indexes
CREATE INDEX idx_notifications_user ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(is_read);
CREATE INDEX idx_notifications_created ON notifications(created_at);

-- Audit logs indexes
CREATE INDEX idx_audit_user ON audit_logs(user_id);
CREATE INDEX idx_audit_action ON audit_logs(action);
CREATE INDEX idx_audit_table ON audit_logs(table_name);
CREATE INDEX idx_audit_created ON audit_logs(created_at);

-- =====================================================
-- FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply updated_at trigger to relevant tables
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_ministries_updated_at BEFORE UPDATE ON ministries
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON departments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_services_updated_at BEFORE UPDATE ON services
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_service_requests_updated_at BEFORE UPDATE ON service_requests
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_documents_updated_at BEFORE UPDATE ON documents
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_payments_updated_at BEFORE UPDATE ON payments
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_system_settings_updated_at BEFORE UPDATE ON system_settings
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_sessions_updated_at BEFORE UPDATE ON user_sessions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_faqs_updated_at BEFORE UPDATE ON faqs
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_news_updated_at BEFORE UPDATE ON news
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to generate request number
CREATE OR REPLACE FUNCTION generate_request_number()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.request_number IS NULL THEN
        NEW.request_number := 'REQ-' || TO_CHAR(NOW(), 'YYYY') || '-' || 
                             LPAD(EXTRACT(DOY FROM NOW())::TEXT, 3, '0') || '-' ||
                             LPAD(nextval('request_number_seq')::TEXT, 6, '0');
    END IF;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create sequence for request numbers
CREATE SEQUENCE request_number_seq START 1;

-- Apply request number trigger
CREATE TRIGGER generate_request_number_trigger BEFORE INSERT ON service_requests
    FOR EACH ROW EXECUTE FUNCTION generate_request_number();

-- Function for audit logging
CREATE OR REPLACE FUNCTION audit_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, new_values)
        VALUES (auth.uid(), TG_OP, TG_TABLE_NAME, NEW.id, to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (auth.uid(), TG_OP, TG_TABLE_NAME, NEW.id, to_jsonb(OLD), to_jsonb(NEW));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values)
        VALUES (auth.uid(), TG_OP, TG_TABLE_NAME, OLD.id, to_jsonb(OLD));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ language 'plpgsql';

-- Apply audit triggers to important tables
CREATE TRIGGER audit_users_trigger
    AFTER INSERT OR UPDATE OR DELETE ON users
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_service_requests_trigger
    AFTER INSERT OR UPDATE OR DELETE ON service_requests
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

CREATE TRIGGER audit_payments_trigger
    AFTER INSERT OR UPDATE OR DELETE ON payments
    FOR EACH ROW EXECUTE FUNCTION audit_trigger_function();

-- =====================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE ministries ENABLE ROW LEVEL SECURITY;
ALTER TABLE departments ENABLE ROW LEVEL SECURITY;
ALTER TABLE services ENABLE ROW LEVEL SECURITY;
ALTER TABLE service_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE audit_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE faqs ENABLE ROW LEVEL SECURITY;
ALTER TABLE news ENABLE ROW LEVEL SECURITY;

-- Users policies
CREATE POLICY "Users can view their own profile" ON users
    FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" ON users
    FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Admins can view all users" ON users
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role IN ('super_admin', 'admin', 'ministry_admin', 'department_admin')
        )
    );

-- Service requests policies
CREATE POLICY "Users can view their own requests" ON service_requests
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own requests" ON service_requests
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own draft requests" ON service_requests
    FOR UPDATE USING (auth.uid() = user_id AND status = 'draft');

CREATE POLICY "Admins can view all requests" ON service_requests
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM users 
            WHERE id = auth.uid() 
            AND role IN ('super_admin', 'admin', 'ministry_admin', 'department_admin', 'employee')
        )
    );

-- Documents policies
CREATE POLICY "Users can view their own documents" ON documents
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can upload their own documents" ON documents
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Payments policies
CREATE POLICY "Users can view their own payments" ON payments
    FOR SELECT USING (auth.uid() = user_id);

-- Notifications policies
CREATE POLICY "Users can view their own notifications" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update their own notifications" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- Public read access for some tables
CREATE POLICY "Public read access for ministries" ON ministries
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for departments" ON departments
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for services" ON services
    FOR SELECT USING (status = 'active');

CREATE POLICY "Public read access for FAQs" ON faqs
    FOR SELECT USING (is_active = true);

CREATE POLICY "Public read access for published news" ON news
    FOR SELECT USING (is_published = true AND (expires_at IS NULL OR expires_at > NOW()));

-- =====================================================
-- STORAGE BUCKETS
-- =====================================================

-- Create storage buckets for file uploads
INSERT INTO storage.buckets (id, name, public) VALUES 
    ('documents', 'documents', false),
    ('profiles', 'profiles', true),
    ('news-images', 'news-images', true),
    ('ministry-logos', 'ministry-logos', true);

-- Storage policies
CREATE POLICY "Users can upload their own documents" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'documents' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Users can view their own documents" ON storage.objects
    FOR SELECT USING (bucket_id = 'documents' AND auth.uid()::text = (storage.foldername(name))[1]);

CREATE POLICY "Public access to profiles" ON storage.objects
    FOR SELECT USING (bucket_id = 'profiles');

CREATE POLICY "Users can upload their own profile images" ON storage.objects
    FOR INSERT WITH CHECK (bucket_id = 'profiles' AND auth.uid()::text = (storage.foldername(name))[1]);

-- =====================================================
-- VIEWS FOR REPORTING
-- =====================================================

-- Service requests summary view
CREATE VIEW service_requests_summary AS
SELECT 
    s.name as service_name,
    m.name as ministry_name,
    COUNT(*) as total_requests,
    COUNT(CASE WHEN sr.status = 'completed' THEN 1 END) as completed_requests,
    COUNT(CASE WHEN sr.status = 'pending' THEN 1 END) as pending_requests,
    AVG(EXTRACT(EPOCH FROM (sr.completed_at - sr.submitted_at))/86400) as avg_processing_days
FROM service_requests sr
JOIN services s ON sr.service_id = s.id
JOIN ministries m ON s.ministry_id = m.id
WHERE sr.submitted_at IS NOT NULL
GROUP BY s.id, s.name, m.name;

-- User statistics view
CREATE VIEW user_statistics AS
SELECT 
    COUNT(*) as total_users,
    COUNT(CASE WHEN role = 'citizen' THEN 1 END) as citizens,
    COUNT(CASE WHEN role IN ('admin', 'ministry_admin', 'department_admin', 'employee') THEN 1 END) as staff,
    COUNT(CASE WHEN is_active = true THEN 1 END) as active_users,
    COUNT(CASE WHEN email_verified = true THEN 1 END) as verified_users
FROM users;

-- Payment statistics view
CREATE VIEW payment_statistics AS
SELECT 
    DATE_TRUNC('month', created_at) as month,
    COUNT(*) as total_payments,
    SUM(amount) as total_amount,
    COUNT(CASE WHEN status = 'completed' THEN 1 END) as successful_payments,
    SUM(CASE WHEN status = 'completed' THEN amount ELSE 0 END) as successful_amount
FROM payments
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month DESC;

-- =====================================================
-- INITIAL DATA
-- =====================================================

-- Insert system settings
INSERT INTO system_settings (key, value, description, is_public) VALUES
    ('app_name', 'تطبيق واصل', 'Application name', true),
    ('app_version', '1.0.0', 'Application version', true),
    ('maintenance_mode', 'false', 'Maintenance mode flag', false),
    ('max_file_size', '10485760', 'Maximum file upload size in bytes (10MB)', false),
    ('allowed_file_types', 'pdf,jpg,jpeg,png,doc,docx', 'Allowed file types for upload', false),
    ('session_timeout', '3600', 'Session timeout in seconds', false),
    ('password_min_length', '8', 'Minimum password length', false),
    ('otp_expiry_minutes', '5', 'OTP expiry time in minutes', false);

-- Insert sample ministries
INSERT INTO ministries (name, name_en, description, contact_email, contact_phone, is_active) VALUES
    ('وزارة الداخلية', 'Ministry of Interior', 'وزارة الداخلية المسؤولة عن الأمن والنظام العام', 'info@moi.gov.ye', '+967-1-123456', true),
    ('وزارة العدل', 'Ministry of Justice', 'وزارة العدل المسؤولة عن القضاء والعدالة', 'info@moj.gov.ye', '+967-1-123457', true),
    ('وزارة الصحة العامة والسكان', 'Ministry of Public Health and Population', 'وزارة الصحة المسؤولة عن الخدمات الصحية', 'info@moph.gov.ye', '+967-1-123458', true),
    ('وزارة التربية والتعليم', 'Ministry of Education', 'وزارة التربية والتعليم المسؤولة عن التعليم', 'info@moe.gov.ye', '+967-1-123459', true),
    ('وزارة المالية', 'Ministry of Finance', 'وزارة المالية المسؤولة عن الشؤون المالية', 'info@mof.gov.ye', '+967-1-123460', true);

-- Insert sample departments
INSERT INTO departments (ministry_id, name, name_en, description) VALUES
    ((SELECT id FROM ministries WHERE name = 'وزارة الداخلية'), 'إدارة الأحوال المدنية', 'Civil Status Department', 'إدارة الأحوال المدنية والسجل المدني'),
    ((SELECT id FROM ministries WHERE name = 'وزارة الداخلية'), 'إدارة الجوازات والهجرة', 'Passport and Immigration Department', 'إدارة الجوازات والهجرة والجنسية'),
    ((SELECT id FROM ministries WHERE name = 'وزارة العدل'), 'إدارة التوثيق', 'Notarization Department', 'إدارة التوثيق والشهادات القانونية'),
    ((SELECT id FROM ministries WHERE name = 'وزارة الصحة العامة والسكان'), 'إدارة الشهادات الطبية', 'Medical Certificates Department', 'إدارة إصدار الشهادات الطبية');

-- Insert sample services
INSERT INTO services (ministry_id, department_id, name, name_en, description, category, service_code, fee_amount, processing_time_days, required_documents) VALUES
    (
        (SELECT id FROM ministries WHERE name = 'وزارة الداخلية'),
        (SELECT id FROM departments WHERE name = 'إدارة الأحوال المدنية'),
        'استخراج شهادة ميلاد',
        'Birth Certificate Issuance',
        'خدمة استخراج شهادة ميلاد جديدة أو بدل فاقد',
        'الأحوال المدنية',
        'SRV-001',
        500.00,
        3,
        ARRAY['national_id', 'birth_certificate']
    ),
    (
        (SELECT id FROM ministries WHERE name = 'وزارة الداخلية'),
        (SELECT id FROM departments WHERE name = 'إدارة الجوازات والهجرة'),
        'استخراج جواز سفر',
        'Passport Issuance',
        'خدمة استخراج جواز سفر جديد أو تجديد',
        'الجوازات',
        'SRV-002',
        15000.00,
        7,
        ARRAY['national_id', 'passport']
    ),
    (
        (SELECT id FROM ministries WHERE name = 'وزارة العدل'),
        (SELECT id FROM departments WHERE name = 'إدارة التوثيق'),
        'توثيق عقد زواج',
        'Marriage Contract Authentication',
        'خدمة توثيق عقد الزواج',
        'التوثيق',
        'SRV-003',
        1000.00,
        1,
        ARRAY['national_id', 'marriage_certificate']
    );

-- Insert sample FAQs
INSERT INTO faqs (question, answer, category, is_active) VALUES
    ('كيف يمكنني استخراج شهادة ميلاد؟', 'يمكنك استخراج شهادة الميلاد من خلال تقديم طلب عبر التطبيق مع إرفاق المستندات المطلوبة', 'الأحوال المدنية', true),
    ('ما هي المستندات المطلوبة لاستخراج جواز السفر؟', 'تحتاج إلى الهوية الوطنية وصورة شخصية ودفع الرسوم المقررة', 'الجوازات', true),
    ('كم يستغرق معالجة الطلب؟', 'يختلف وقت المعالجة حسب نوع الخدمة، عادة من يوم إلى أسبوع', 'عام', true);

-- =====================================================
-- FUNCTIONS FOR BUSINESS LOGIC
-- =====================================================

-- Function to get user's active requests
CREATE OR REPLACE FUNCTION get_user_active_requests(user_uuid UUID)
RETURNS TABLE (
    request_id UUID,
    service_name VARCHAR,
    status request_status,
    submitted_at TIMESTAMP WITH TIME ZONE,
    estimated_completion_date DATE
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        sr.id,
        s.name,
        sr.status,
        sr.submitted_at,
        sr.estimated_completion_date
    FROM service_requests sr
    JOIN services s ON sr.service_id = s.id
    WHERE sr.user_id = user_uuid
    AND sr.status NOT IN ('completed', 'cancelled')
    ORDER BY sr.created_at DESC;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to get service statistics
CREATE OR REPLACE FUNCTION get_service_statistics(service_uuid UUID)
RETURNS TABLE (
    total_requests BIGINT,
    completed_requests BIGINT,
    pending_requests BIGINT,
    avg_processing_time NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*) as total_requests,
        COUNT(CASE WHEN status = 'completed' THEN 1 END) as completed_requests,
        COUNT(CASE WHEN status IN ('submitted', 'under_review') THEN 1 END) as pending_requests,
        AVG(EXTRACT(EPOCH FROM (completed_at - submitted_at))/86400) as avg_processing_time
    FROM service_requests
    WHERE service_id = service_uuid
    AND submitted_at IS NOT NULL;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Function to send notification
CREATE OR REPLACE FUNCTION send_notification(
    recipient_id UUID,
    notification_title VARCHAR,
    notification_message TEXT,
    notification_type notification_type DEFAULT 'info',
    action_url TEXT DEFAULT NULL
)
RETURNS UUID AS $$
DECLARE
    notification_id UUID;
BEGIN
    INSERT INTO notifications (user_id, title, message, type, action_url)
    VALUES (recipient_id, notification_title, notification_message, notification_type, action_url)
    RETURNING id INTO notification_id;
    
    RETURN notification_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- =====================================================
-- CLEANUP AND MAINTENANCE
-- =====================================================

-- Function to cleanup expired sessions
CREATE OR REPLACE FUNCTION cleanup_expired_sessions()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM user_sessions 
    WHERE expires_at < NOW() OR (is_active = false AND updated_at < NOW() - INTERVAL '30 days');
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Function to cleanup old audit logs (keep last 2 years)
CREATE OR REPLACE FUNCTION cleanup_old_audit_logs()
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM audit_logs 
    WHERE created_at < NOW() - INTERVAL '2 years';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- COMMENTS FOR DOCUMENTATION
-- =====================================================

COMMENT ON TABLE users IS 'Extended user profile information linked to Supabase auth';
COMMENT ON TABLE ministries IS 'Government ministries and entities';
COMMENT ON TABLE departments IS 'Departments within ministries';
COMMENT ON TABLE services IS 'Government services offered to citizens';
COMMENT ON TABLE service_requests IS 'Citizen requests for government services';
COMMENT ON TABLE documents IS 'Documents uploaded by users for their requests';
COMMENT ON TABLE payments IS 'Payment records for service fees';
COMMENT ON TABLE notifications IS 'System notifications sent to users';
COMMENT ON TABLE audit_logs IS 'Audit trail for all system activities';

-- =====================================================
-- END OF SCHEMA
-- =====================================================