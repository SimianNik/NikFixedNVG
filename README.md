

# NikFixedNVG

### “It's like looking through a straw”

<img width="1920" height="1080" alt="NikNvgChanges" src="https://github.com/user-attachments/assets/22035fcf-f91f-46a4-86c4-0418efa8c50f" />


This mod adjusts the DCS Night Vision Goggles (NVGs) by:

- Making the **“green circle” keep a constant world-space size** regardless of camera zoom/FOV
    
- Allowing the mask to become an **oval**, instead of a perfect circle
    
- Allowing **easy user adjustment** of NVG size, position, and shape

This mod is **not tested in VR** and **does break integrity check**.  
There is no workaround — and using it in competitive environments would be considered an advantage ("cheating") I.M.O.

---
#### Preface:

I've never used aviation NVGs in real life. But after many hours in DCS — especially on small monitors — I’ve always found two things difficult:

 1.   **Inside the cockpit**, everything behind the goggles becomes too blurry to use.
 2. **Outside the goggles**, the world visible beyond the “green circle” is tiny and hard to read.

The biggest issue, though, is that the **NVG visible world changes size depending on the camera zoom level (FOV)**.
Real goggles don’t do that — your eye zooming doesn’t change the NVG FOV. No matter if you're a pigeon or a person, you only see the same "Amount of night vision revealed"

This mod does _not_ aim for perfect realism, but it tries to improve usability while keeping the NVGs reasonably authentic, using a very light-weight modification.

---
#### What’s Modified:

 - **Oval NVG Shape (adjustable):**  
    The original mask is a perfect circle. Now it can be stretched or compressed horizontally or vertically.
    
-   **Mask Position (adjustable):**  
    DCS places the NVGs slightly high on the screen. You can now shift them up or down easily.
    
-   **Fixed FOV Behavior:**  
    The NVG field of view stays the same in the _world_, even when the camera zooms.
    
    -   Zooming out → the circle appears smaller on screen, revealing more cockpit
        
    -   Zooming in → the mask fills more of the screen
        
    -   Excess zoom is capped so the NVGs don’t become absurdly large
        
This is closer to how real NVGs behave:  _the goggles don’t zoom, your eyes do_.

---
#### Manual Installation:

This mod consists of a single file that replaces a DCS **core shader**, so it **cannot** be installed via the Saved Games folder.

You must overwrite (replace): `DCS World OpenBeta/Bazar/Shaders/PostEffects/NVD_common.hlsl`  with the included file. (You can download it from the "Releases" section  https://github.com/SimianNik/NikFixedNVG/releases)


> **Make a backup of the original file**  
> (or keep the original version included in this repo inside the comment block)

---
#### Usage:

Nothing changes in-game operationally — just activate NVGs as usual (`RShift + H` by default).

To tweak values like NVG size, oval shape, or position:

1.  Open the file:  `NVD_common.hlsl`
2.  Modify the numeric values in the **User-Controllable Parameters** section.
    
Changes take effect when you reload the game.

---
#### Customization:

Inside `NVD_common.hlsl` look for:

     // ---------------------------------------------------------------  
     // User-Controllable Parameters  
     // --------------------------------------------------------------- 

The parameters below it define all user adjustments:

| Parameter | Description |
|--|--|
| **NVD_OFFSET_VERT** | Vertical screen offset of the NVG mask. Positive = higher.|
|**NVD_OVAL_X**|Horizontal stretch of the NVG oval ( >1 = wider ).|
|**NVD_OVAL_Y** |Vertical stretch of the NVG oval ( >1 = taller ).
|**NVD_SIZE**|Effective “FOV” of the NVGs. Lower value = smaller goggles, higher value = bigger goggles. <br> 0.5 is roughly 45° FOV (a bit more than real life references)
|**NVD_MAX_SCALE**|Maximum on-screen size (prevents over-growth when zooming in).
|**NVD_MIN_SCALE**|Minimum on-screen size (prevents over-shrink when zooming out).

Example modification:
```cpp
float NVD_SIZE = 0.5;
```
 change  to:
```cpp
float NVD_SIZE = 0.4;
```
(Only modify the values)

---
####  **Known Bugs:**

The circle is **mostly** fixed in world space — but not 100% perfect.  
A very small size fluctuation remains when zooming.

However, it’s still _far_ more consistent than the default DCS behavior I.M.O

---
Happy DCS hunting, own the night.
