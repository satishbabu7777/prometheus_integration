package com.ecommerce.booking.entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "booking")
public class Booking {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Long userId;

    private Long flightId;

    private String status;

    public void setUserId(Long userId2) {
      this.userId = userId2;
    }

    public void setFlightId(Long flightId2) {
        this.flightId = flightId2;
    }

    public void setStatus(String status2) {
        this.status = status2;
    }
}
