#include QMK_KEYBOARD_H

#define  LAYER0 0
#define _RAISE  1
#define _RAISE2 2
#define _RAISE3 3

/* #define LAYER2 2 */
/* #define QWERTY  0 // Base qwerty of Stapelberg */
/* #define LAYER1_ 4 */
/* #define LAYER2_ 5 */

enum unicode_names {
    Amin,
    Amay,
    Omin,
    Omay,
    Emin,
    Emay,
    Umin,
    Umay,
    Imin,
    Imay,
    Ene_min,
    Ene_may,
    UminDierisis,
    UmayDierisis,
    InterrogacionAbierto,
    ExclamacionAbierto,
    Euro,
};

const uint32_t PROGMEM unicode_map[] = {
[Amin]  = 0x00E1,
[Amay]  = 0x00C1,
[Omin]  = 0x00F3,
[Omay]  = 0x00D3,
[Emin]  = 0x00E9,
[Emay]  = 0x00C9,
[Umin]  = 0x00FA,
[Umay]  = 0x00DA,
[Imin]  = 0x00ED,
[Imay]  = 0x00CD,
[Ene_min]  = 0x00F1,
[Ene_may]  = 0x00D1,
[UminDierisis]  = 0x00FC,
[UmayDierisis]  = 0x00DC,

[InterrogacionAbierto]  = 0x00BF,
[ExclamacionAbierto]  = 0x00A1,

[Euro]  = 0x20AC,

};

// clang-format off

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
 [LAYER0] = LAYOUT(
                KC_CAPS ,KC_F1      ,KC_F2   ,KC_F3   ,KC_F4   ,KC_F5    ,KC_F6   ,KC_F7   ,KC_F8            ,KC_F9   ,KC_F10  ,KC_F11  ,KC_F12 ,KC_PSCR, KC_SCRL ,OSL(_RAISE) ,TG(_RAISE) ,QK_BOOT

 /* 1 row */   ,KC_EQL  ,KC_PLUS    ,KC_LBRC ,KC_LCBR ,KC_LPRN ,KC_PERC              ,KC_CIRC ,KC_AMPR ,KC_ASTR ,KC_AT ,KC_EXLM ,KC_MINS
 /* 2 row */   ,KC_TAB  ,KC_DQUO    ,KC_COMM ,KC_DOT  ,KC_P    ,KC_Y                 ,KC_F    ,KC_G    ,KC_C    ,KC_H  ,KC_L    ,KC_SLSH
 /* 3 row */   ,KC_ESC  ,KC_A       ,KC_O    ,KC_E    ,KC_U    ,KC_I                 ,KC_D    ,KC_R    ,KC_T    ,KC_N  ,KC_S    ,S(KC_3)
 /* 4 row */   ,KC_LSFT ,S(KC_SCLN) ,KC_Q    ,KC_J    ,KC_K    ,KC_X                 ,KC_B    ,KC_M    ,KC_W    ,KC_V  ,KC_Z    ,KC_RSFT

 /* 5 row */            ,KC_A       ,KC_A    ,KC_LEFT ,KC_RGHT                       ,KC_UP   ,KC_DOWN ,KC_A    ,KC_A

                                                          ,KC_LCTL ,KC_LALT        ,KC_RCTL  ,KC_LGUI
                                                          ,KC_HOME ,KC_PGUP

                                                 ,KC_BSPC ,MO(_RAISE) ,KC_END ,KC_PGDN ,KC_ENTER ,KC_SPC
),


 [_RAISE] = LAYOUT(
                _______  ,_______    ,_______ ,_______ ,_______    ,_______    ,_______   ,_______   ,_______          ,_______   ,_______  ,_______  ,_______ ,_______ ,_______ ,_______, _______, _______

 /* 1 row */   ,_______  ,KC_1       ,KC_2    ,KC_3    ,KC_4       ,KC_5                    ,KC_6       ,KC_7       ,KC_8       ,KC_9     ,KC_0       ,S(KC_MINS)
 /* 2 row */   ,_______  ,KC_QUOT    ,_______ ,_______ ,KC_DOLLAR  ,KC_GRV                  ,_______    ,_______    ,_______    ,_______  ,_______    ,KC_BSLS
 /* 3 row */   ,KC_LSFT  ,UP(Amin, Amay) ,UP(Omin, Omay) ,UP(Emin, Emay), UP(Umin, Umay) ,UP(Imin, Imay)      ,KC_DEL    ,_______    ,KC_QUES    ,UP(Ene_min, Ene_may)  ,KC_TILD    ,S(KC_BSLS)
 /* 4 row */   ,_______ ,KC_SCLN     ,_______ ,_______ ,MO(_RAISE2),_______                 ,_______    ,_______    ,_______    ,_______  ,_______    ,_______

 /* 5 row */            ,_______     ,_______ ,_______ ,_______                             ,_______    ,_______    ,_______    ,_______

                                                          ,_______ ,_______        ,_______  ,_______
                                                          ,_______ ,_______

                                                 ,_______ ,_______ ,_______ ,_______ ,OSL(_RAISE3) ,KC_RALT
),
 [_RAISE2] = LAYOUT(
                _______ ,_______   ,_______ ,_______  ,_______  ,_______    ,_______   ,_______   ,_______   ,_______     ,_______  ,_______  ,_______ ,_______ ,_______ ,_______, _______, _______

 /* 1 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,S(KC_0)   ,S(KC_RBRC) ,KC_RBRC  ,_______    ,_______
 /* 2 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,_______  ,_______     ,_______  ,_______    ,_______
 /* 3 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,_______  ,_______     ,_______  ,_______    ,_______
 /* 4 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,_______  ,_______     ,_______  ,_______    ,_______

 /* 5 row */            ,_______   ,_______ ,_______  ,_______                          ,_______  ,_______    ,_______    ,_______

                                                          ,_______ ,_______        ,_______  ,_______
                                                          ,_______ ,_______

                                                 ,_______ ,_______ ,_______ ,_______ ,_______ ,_______
),


 [_RAISE3] = LAYOUT(
                _______ ,_______   ,_______ ,_______  ,_______  ,_______    ,_______   ,_______   ,_______   ,_______     ,_______  ,_______  ,_______ ,_______ ,_______ ,_______, _______, _______

 /* 1 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,_______  ,_______ ,_______  ,_______    ,_______
 /* 2 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,_______  ,_______ ,_______  ,_______    ,_______
 /* 3 row */   ,_______ ,_______   ,_______ ,UM(Euro) ,UP(UminDierisis, UmayDierisis)  ,_______                ,_______   ,_______  ,UM(InterrogacionAbierto) ,UM(ExclamacionAbierto)  ,_______    ,_______
 /* 4 row */   ,_______ ,_______   ,_______ ,_______  ,_______  ,_______                ,_______   ,_______  ,_______ ,_______  ,_______    ,_______

 /* 5 row */            ,_______   ,_______ ,_______  ,_______                          ,_______  ,_______    ,_______    ,_______

                                                          ,_______ ,_______        ,_______  ,_______
                                                          ,_______ ,_______

                                                 ,_______ ,_______ ,_______ ,_______ ,_______ ,_______
),


};

