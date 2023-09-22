package com.example.Skill.Hands.dto;

import java.io.Serializable;
import java.sql.Date;

public class ServiceAvailedDto implements Serializable {

    private int id;
    private int serviceId;
    private int citizenId;
    private int skillHandId;
    private Date serviceAvailedDate;

    public ServiceAvailedDto() {}

    public ServiceAvailedDto(int id, int serviceId, int citizenId, int skillHandId, Date serviceAvailedDate) {
        this.id = id;
        this.serviceId = serviceId;
        this.citizenId = citizenId;
        this.skillHandId = skillHandId;
        this.serviceAvailedDate = serviceAvailedDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getServiceId() {
        return serviceId;
    }

    public void setServiceId(int serviceId) {
        this.serviceId = serviceId;
    }

    public int getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(int citizenId) {
        this.citizenId = citizenId;
    }

    public int getSkillHandId() {
        return skillHandId;
    }

    public void setSkillHandId(int skillHandId) {
        this.skillHandId = skillHandId;
    }

    public Date getServiceAvailedDate() {
        return serviceAvailedDate;
    }

    public void setServiceAvailedDate(Date serviceAvailedDate) {
        this.serviceAvailedDate = serviceAvailedDate;
    }
}

