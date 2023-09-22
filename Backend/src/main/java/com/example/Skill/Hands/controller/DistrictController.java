package com.example.Skill.Hands.controller;

import com.example.Skill.Hands.entity.BlockEntity;
import com.example.Skill.Hands.entity.DistrictEntity;
import com.example.Skill.Hands.repository.DistrictRepo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@RestController
public class DistrictController {

    @Autowired
    public DistrictRepo districtRepo;

    @GetMapping("/findAllDistrict")
    public List<DistrictEntity> findAllDistrict() {
        return districtRepo.findAll();
    }

    @PostMapping("/addDistrict")
    public ResponseEntity addDistrict(@RequestBody DistrictEntity districtEntity) {

        DistrictEntity entity = new DistrictEntity();

        entity.setDistrictCode(districtEntity.getDistrictCode());
        entity.setDistrictName(districtEntity.getDistrictName());


        districtRepo.save(entity);

        return ResponseEntity.ok(districtEntity.getDistrictName() + " district added");
    }

    @GetMapping("/getIdByName/{districtName}")
    public int getIdByName(@PathVariable String districtName) {
        DistrictEntity entity = districtRepo.findIdByDistrictName(districtName);

        if (districtRepo.findIdByDistrictName(districtName) != null) {
            return entity.getDistrictCode();
        }
        return 0;
    }

    @GetMapping("/findByDistrictCode/{districtCode}")
    public List<DistrictEntity> findByDistrictCode(@PathVariable int districtCode) {

        return districtRepo.findByDistrictCode(districtCode);

    }

}
