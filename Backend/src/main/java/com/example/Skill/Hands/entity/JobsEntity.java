package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name = "ref_jobs")
public class JobsEntity implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    public int jobId;
    @Column(name = "skill", nullable = false)
    public String skill;

    public int getJobId() {
        return jobId;
    }

    public void setJobId(int id) {
        this.jobId = id;
    }

    public String getSkill() {
        return skill;
    }

    public void setSkill(String skill) {
        this.skill = skill;
    }

}
