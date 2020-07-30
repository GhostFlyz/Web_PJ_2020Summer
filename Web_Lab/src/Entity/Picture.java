package Entity;

import java.sql.Timestamp;

public class Picture {
    private String ID;
    private String title;
    private String description;
    private String cityName;
    private String countryName;
    private String author;
    private String path;
    private String content;
    private int likePerson;
    private Timestamp update;

    public Picture(String ID, String title, String description, String cityName, String countryName, String author, String path, String content, int likePerson, Timestamp update) {
        this.ID = ID;
        this.title = title;
        this.description = description;
        this.cityName = cityName;
        this.countryName = countryName;
        this.author = author;
        this.path = path;
        this.content = content;
        this.likePerson = likePerson;
        this.update = update;
    }

    @Override
    public String toString() {
        return "Picture{" +
                "ID='" + ID + '\'' +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", cityName='" + cityName + '\'' +
                ", countryName='" + countryName + '\'' +
                ", author='" + author + '\'' +
                ", path='" + path + '\'' +
                ", content='" + content + '\'' +
                ", likePerson=" + likePerson +
                '}';
    }

    public Picture() {
    }

    public int getLikePerson() {
        return likePerson;
    }

    public void setLikePerson(int likePerson) {
        this.likePerson = likePerson;
    }

    public String getID() {
        return ID;
    }

    public void setID(String ID) {
        this.ID = ID;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCityName() {
        return cityName;
    }

    public void setCityName(String cityName) {
        this.cityName = cityName;
    }

    public String getCountryName() {
        return countryName;
    }

    public void setCountryName(String countryName) {
        this.countryName = countryName;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getUpdate() {
        return update;
    }

    public void setUpdate(Timestamp update) {
        this.update = update;
    }
}


