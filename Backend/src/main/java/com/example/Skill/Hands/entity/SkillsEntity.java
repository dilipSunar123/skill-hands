package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "skill_hands")
public class SkillsEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int id;

    @Column(name = "name", nullable = false)
    public String name;

    @Column(name = "address", nullable = false)
    public String address;

    @Column(name = "experience", nullable = false)
    public String experience;

    @Column(name = "rating", nullable = false)
    public int rating;

    @Column(name = "contact", nullable = false)
    public String contact;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "job_id")
    public JobsEntity jobsEntity;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "district_id")
    private DistrictEntity districtEntity;



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


    public JobsEntity getJobsEntity() {
        return jobsEntity;
    }

    public void setJobsEntity(JobsEntity jobsEntity) {
        this.jobsEntity = jobsEntity;
    }

    public DistrictEntity getDistrictEntity() {
        return districtEntity;
    }

    public void setDistrictEntity(DistrictEntity districtEntity) {
        this.districtEntity = districtEntity;
    }
}
