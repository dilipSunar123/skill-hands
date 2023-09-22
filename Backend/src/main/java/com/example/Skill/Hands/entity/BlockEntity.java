package com.example.Skill.Hands.entity;

import jakarta.persistence.*;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "block_table")
public class BlockEntity {

    @Id
    private int blockCode;
    private String blockName;


    @ManyToOne
    @JoinColumn(name = "districtCode")
    private DistrictEntity districtCode;

    public BlockEntity() {}

    public BlockEntity(int blockCode, String blockName, DistrictEntity districtCode) {
        this.blockCode = blockCode;
        this.blockName = blockName;
        this.districtCode = districtCode;
    }

    public int getBlockCode() {
        return blockCode;
    }

    public void setBlockCode(int blockCode) {
        this.blockCode = blockCode;
    }

    public String getBlockName() {
        return blockName;
    }

    public void setBlockName(String blockName) {
        this.blockName = blockName;
    }

    public DistrictEntity getDistrictCode() {
        return districtCode;
    }

    public void setDistrictCode(DistrictEntity districtCode) {
        this.districtCode = districtCode;
    }
}
