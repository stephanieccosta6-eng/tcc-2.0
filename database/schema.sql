CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    skin_type VARCHAR(60) DEFAULT 'Pele Mista',
    skin_goal VARCHAR(120) DEFAULT 'Hidratação & Luminosidade',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE glow_fridge (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    current_temp DECIMAL(4,1) DEFAULT 6.0,
    status_mode VARCHAR(30) DEFAULT 'Ideal'
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    total DECIMAL(10,2) NOT NULL,
    status VARCHAR(40) DEFAULT 'Confirmado',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
