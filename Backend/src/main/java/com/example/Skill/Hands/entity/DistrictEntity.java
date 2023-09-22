package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "district_table")
public class DistrictEntity {

    @Id
    private int districtCode;
    private String districtName;

    public DistrictEntity() {}

    public DistrictEntity(int districtCode, String districtName) {
        this.districtCode = districtCode;
        this.districtName = districtName;
    }

    public int getDistrictCode() {
        return districtCode;
    }

    public void setDistrictCode(int districtCode) {
        this.districtCode = districtCode;
    }

    public String getDistrictName() {
        return districtName;
    }

    public void setDistrictName(String districtName) {
        this.districtName = districtName;
    }

}
