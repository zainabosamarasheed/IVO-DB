
-- إنشاء قاعدة البيانات
CREATE DATABASE magazine_platform;

-- الاتصال بقاعدة البيانات (في بعض البيئات يتم ذلك يدوياً)
-- \c magazine_platform;

-- جدول المستخدمين
CREATE TABLE Users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) CHECK (role IN ('guest', 'author', 'verified', 'moderator', 'admin')) NOT NULL DEFAULT 'guest',
    is_verified BOOLEAN DEFAULT FALSE,
    verification_docs TEXT,
    whatsapp_number VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول المقالات
CREATE TABLE Articles (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    category VARCHAR(50),
    author_id INTEGER REFERENCES Users(id) ON DELETE SET NULL,
    is_featured BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT FALSE,
    type VARCHAR(20) CHECK (type IN ('normal', 'research', 'thesis')) DEFAULT 'normal',
    view_count INTEGER DEFAULT 0,
    reading_time INTEGER,
    status VARCHAR(20) CHECK (status IN ('pending', 'published', 'rejected')) DEFAULT 'pending',
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول الرسائل الجامعية
CREATE TABLE Thesis (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    abstract TEXT,
    file_url TEXT NOT NULL,
    author_id INTEGER REFERENCES Users(id) ON DELETE SET NULL,
    is_verified BOOLEAN DEFAULT FALSE,
    verification_docs TEXT,
    status VARCHAR(20) CHECK (status IN ('pending', 'published', 'rejected')) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول المقالات المميزة (اختياري)
CREATE TABLE Featured_Articles (
    article_id INTEGER PRIMARY KEY REFERENCES Articles(id) ON DELETE CASCADE,
    calculated_score FLOAT,
    featured_from_date DATE,
    featured_until_date DATE
);

-- جدول رسائل التواصل
CREATE TABLE Contact_Messages (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(id) ON DELETE SET NULL,
    name VARCHAR(100),
    subject TEXT,
    message TEXT,
    replied BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- جدول إشعارات الإدارة
CREATE TABLE Admin_Notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES Users(id) ON DELETE SET NULL,
    type VARCHAR(50),
    status VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- مؤشرات لتحسين الأداء
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_articles_author ON Articles(author_id);
CREATE INDEX idx_thesis_author ON Thesis(author_id);
CREATE INDEX idx_notifications_user ON Admin_Notifications(user_id);

-- نهاية السكربت
