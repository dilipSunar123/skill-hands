package com.example.Skill.Hands.repository;

import com.example.Skill.Hands.entity.DistrictEntity;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DistrictRepo extends JpaRepository<DistrictEntity, Integer> {

    public DistrictEntity findIdByDistrictName(String districtName);
    public List<DistrictEntity> findByDistrictCode(int districtCode);

}
