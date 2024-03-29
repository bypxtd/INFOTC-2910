DROP TABLE IF EXISTS ArticleTag;
DROP TABLE IF EXISTS Tag;
DROP TABLE IF EXISTS Featured;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Bookmark;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Article;
DROP TABLE IF EXISTS User;

CREATE TABLE User (
    UserID INT AUTO_INCREMENT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(50),
    Username VARCHAR(50),
    Usertype VARCHAR(50) DEFAULT 'U',
    Password VARCHAR(255),
    ProfilePicture VARCHAR(500) DEFAULT 'defaultAvatar.png',
    Bio VARCHAR(200) DEFAULT NULL,
    City VARCHAR(50) DEFAULT NULL,
    TimeZone ENUM('US/Hawaii','US/Alaska','US/Pacific','US/Mountain','US/Central','US/Eastern'),
    State ENUM('Alabama','Alaska','Arizona','Arkansas','California','Colorado','Connecticut','Delaware','District Of Columbia','Florida','Georgia','Hawaii','Idaho','Illinois','Indiana','Iowa','Kansas','Kentucky','Louisiana','Maine','Maryland','Massachusetts','Michigan','Minnesota','Mississippi','Missouri','Montana','Nebraska','Nevada','New Hampshire','New Jersey','New Mexico','New York','North Carolina','North Dakota','Ohio','Oklahoma','Oregon','Pennsylvania','Rhode Island','South Carolina','South Dakota','Tennessee','Texas','Utah','Vermont','Virginia','Washington','West Virginia','Wisconsin','Wyoming'),
    DateFormat ENUM('F j, Y','j F Y','m/d/y','d/m/y','l jS \\of F Y'),
	tfaStatus TINYINT(1),
	qrCode VARCHAR(16),
	RecoveryCode VARCHAR(255),
    CONSTRAINT PKUser PRIMARY KEY (UserID)
);

CREATE TABLE Article (
    ArticleID INT AUTO_INCREMENT,
    UserID INT DEFAULT NULL,
    Headline VARCHAR(255),
    Body VARCHAR(10000),
    Category VARCHAR(50),
    PublishDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    Views MEDIUMINT(9) DEFAULT 0,
    ArticleImage VARCHAR(500) DEFAULT 'https://i.imgur.com/U469uHI.jpg',
    ArticleRating DOUBLE DEFAULT 0,
    CommentsEnabled BOOLEAN DEFAULT true,
    IsDraft BOOLEAN DEFAULT true,
    IsSubmitted BOOLEAN DEFAULT false,
    FOREIGN KEY (UserID) REFERENCES User (UserID) ON DELETE SET NULL,
    CONSTRAINT PKArticle PRIMARY KEY (ArticleID)
);

CREATE TABLE Comment (
    CommentID INT AUTO_INCREMENT,
    ReplyToID INT DEFAULT NULL,
    UserID INT DEFAULT NULL,
    ArticleID INT DEFAULT NULL,
    CommentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CommentText VARCHAR(8000),
    Edited BOOLEAN DEFAULT false,
    FOREIGN KEY (UserID) REFERENCES User (UserID) ON DELETE SET NULL,
    FOREIGN KEY (ArticleID) REFERENCES Article (ArticleID) ON DELETE CASCADE,
    CONSTRAINT PKComment PRIMARY KEY (CommentID)

);

CREATE TABLE Bookmark (
    UserID INT DEFAULT NULL,
    ArticleID INT DEFAULT NULL,
    FOREIGN KEY (UserID) REFERENCES User (UserID) ON DELETE CASCADE,
    FOREIGN KEY (ArticleID) REFERENCES Article (ArticleID) ON DELETE CASCADE,
    CONSTRAINT PKBookmark PRIMARY KEY (UserID, ArticleID)
);

CREATE TABLE Rating (
    UserID INT DEFAULT NULL,
    ArticleID INT DEFAULT NULL,
    Score DOUBLE DEFAULT NULL,
    FOREIGN KEY (UserID) REFERENCES User (UserID) ON DELETE SET NULL,
    FOREIGN KEY (ArticleID) REFERENCES Article (ArticleID) ON DELETE CASCADE,
    CONSTRAINT idx UNIQUE KEY (UserID, ArticleID)
);

CREATE TABLE Featured (
    FeaturedID INT AUTO_INCREMENT,
    FeaturedType ENUM('EditorPick', 'Main'),
    ArticleID INT DEFAULT NULL,
    FOREIGN KEY (ArticleID) REFERENCES Article (ArticleID) ON DELETE CASCADE,
    CONSTRAINT PKFeatured PRIMARY KEY (FeaturedID)
);

CREATE TABLE Tag (
    TagID INT AUTO_INCREMENT,
    TagName VARCHAR(50),
    CONSTRAINT PKTag PRIMARY KEY (TagID)
);

CREATE TABLE ArticleTag (
    ArticleID INT DEFAULT NULL,
    TagID INT DEFAULT NULL,
    FOREIGN KEY (ArticleID) REFERENCES Article (ArticleID) ON DELETE CASCADE,
    FOREIGN KEY (TagID) REFERENCES Tag (TagID) ON DELETE CASCADE
);