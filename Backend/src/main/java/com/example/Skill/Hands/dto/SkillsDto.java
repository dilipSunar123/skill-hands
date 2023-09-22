package com.example.Skill.Hands.dto;

import com.example.Skill.Hands.entity.DistrictEntity;
import com.example.Skill.Hands.entity.JobsEntity;

import java.io.Serializable;

public class SkillsDto implements Serializable {

    private int id;
    private String name;
    private String address;
    private String experience;
    private int rating;
    private String contact;
    private int jobId;
    private int districtCode;


    public SkillsDto() {}

    public SkillsDto(int id, String name, String address, String experience, int rating, String contact, int jobId, int districtCode) {
        this.id = id;
        this.name = name;
        this.address = address;
        this.experience = experience;
        this.rating = rating;
        this.contact = contact;
        this.jobId = jobId;
        this.districtCode = districtCode;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getExperience() {
        return experience;
    }

    public void setExperience(String experience) {
        this.experience = experience;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact;
    }

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int jobId) {
        this.jobId = jobId;
    }

    public int getDistrictCode() {
        return districtCode;
    }

    public void setDistrictCode(int districtCode) {
        this.districtCode = districtCode;
    }
}
