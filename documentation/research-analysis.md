# Shade Shifter: Initial Research and POC Direction

## Product vision

Shade Shifter is an eyewear product whose frame color can be changed by the wearer through an Android or iOS application. The intended experience includes solid colors, curated shades, zones, and—if the production technology permits—gradients.

The central engineering challenge is a premium-looking, sunlight-visible, multicolor frame surface that is thin, lightweight, sweat-resistant, low-power, durable, safe, and manufacturable at consumer scale.

## Market hypothesis

Electronically adjustable eyewear has commercial validation, but existing products primarily change lens behavior or appearance. Physical overlay systems also demonstrate demand for changing the appearance of a frame. Shade Shifter's proposed whitespace is:

> A seamless, app-controlled, recolorable frame body that remains compatible with conventional prescription lenses.

Relevant market signals identified during the initial research include:

- Chamelo Aura demonstrates interest in electronically color-changing eyewear, focused on lenses.
- Pair Eyewear demonstrates demand for changing frame appearance through physical magnetic overlays.
- India offers a large vision-correction population and growing fashion-eyewear demand, making it a credible first launch market.

## Recommended POC strategy

Run two tracks in parallel:

### 1. Experience POC

Build a Bluetooth-controlled RGB or light-guide frame capable of demonstrating solid colors, independently controlled zones, and simple gradients. This track exists to validate the user experience and create a compelling customer and investor demonstration.

The illuminated prototype is a demonstration platform; it should not automatically be treated as the production architecture.

### 2. Materials POC

Test flexible electrochromic or reflective color-changing material coupons for:

- Passive and active color quality
- Daylight visibility
- Curvature and adhesion
- Sweat and skin-contact resistance
- UV stability
- Switching speed
- Energy use
- Cycle life

This track determines whether the eventual product can resemble premium eyewear rather than an illuminated gadget.

## Recommended first product definition

- Prescription-compatible chassis that can also support sunglasses
- Recolorable frame, not recolorable lenses
- Three controllable areas: front, left temple, and right temple
- 8–16 curated premium colors for generation one
- Physical preset button plus Android/iOS application
- Minimum target battery life of five days
- Target total weight below 40 grams
- Target retail price of ₹14,999–₹19,999
- No mandatory subscription
- Arbitrary RGB gradients retained as an R&D objective until the materials track proves them manufacturable

## POC levels

| Level | Indicative budget | Expected result |
|---|---:|---|
| Lean proof | ₹3–₹5 lakh | One or two visual units, a basic app, and early customer validation |
| Recommended dual-track | ₹8–₹15 lakh | Three wearable units plus electrochromic/material investigation |
| Investor-ready prototype | ₹18–₹30 lakh | Custom electronics, industrial design, and a polished demonstration |

Recommended schedule: 10–12 weeks, with an initial demand go/no-go gate after two weeks.

## Proposed technical architecture

### Hardware

- Prescription-compatible modular eyewear chassis
- Three independently controllable frame zones
- Low-power Bluetooth microcontroller
- RGB/light-guide assembly for the experience prototype
- Electrochromic or reflective coupons for the materials track
- Rechargeable battery, charging and protection circuitry
- Physical preset/control button
- Thermal, electrical, and mechanical safety provisions

### Software

- Cross-platform Android/iOS application, initially using Flutter
- Bluetooth Low Energy communication
- Curated color and preset selection
- Zone control and simple gradient configuration
- Battery status, connection state, and firmware information
- Embedded firmware for control, power management, presets, and fail-safe behavior

## Validation program

The POC should include documented tests for:

- Color consistency and daylight visibility
- Battery life and charging behavior
- Surface and electronics temperature
- Sweat, splash, and cleaning-agent exposure
- UV exposure and color degradation
- Flex, hinge, drop, and wear durability
- Switching and button cycle life
- Bluetooth reliability and reconnect behavior
- User comfort, weight distribution, and prescription-lens compatibility

## Compliance and intellectual property

Early planning should cover:

- ISO 12870 eyewear-frame requirements
- Battery transport and product-safety requirements
- Bluetooth qualification
- India BIS and radio requirements where applicable
- Skin-contact material safety
- Patent landscaping and freedom-to-operate review before architecture lock-in

## Go-to-market direction

Use an India-first, globally compliant engineering strategy. Early validation should focus on fashion-conscious prescription-eyewear users and premium sunglass buyers. The launch approach should combine direct customer discovery with optician and retail-partner interviews.

Key commercial tests include willingness to pay, preferred colors and use cases, comfort expectations, prescription fulfillment, return risk, durability concerns, and whether customers view electronic recoloring as meaningfully better than owning multiple conventional frames.

## Immediate priorities

1. Interview target users and retail partners during the first two weeks.
2. Establish explicit demand, willingness-to-pay, weight, appearance, and battery-life gates.
3. Source experience-prototype electronics and multiple candidate color-changing materials.
4. Build and test flat material coupons before integrating materials into a curved frame.
5. Build the Bluetooth/app experience prototype in parallel.
6. Review results at the two-week demand gate and at the end of the 10–12 week POC.
7. Select a production technology only after comparing appearance, durability, power, weight, cost, and manufacturability.

## Repository organization

- `software/`: mobile application, embedded firmware, shared protocols, and tests
- `hardware/`: electronics, mechanical design, material experiments, BOMs, and test data
- `documentation/`: product research, plans, architecture decisions, compliance work, and project documentation

## Source note

This document captures all substantive research and recommendations available in the supplied conversation transcript. The transcript referenced a more extensive downloadable blueprint, but that original artifact was not included with the handoff.
