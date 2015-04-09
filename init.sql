DROP DATABASE IF EXISTS reviewboard;
CREATE DATABASE IF NOT EXISTS reviewboard CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';
GRANT ALL ON reviewboard.* TO reviewboard@'%' IDENTIFIED BY 'reviewboard';
