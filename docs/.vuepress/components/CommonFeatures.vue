<template>
    <input :style="{ margin: ['10px'] }" type="text" :id="symbols" v-model="smb" @update:model-value="update('onback', picked)" />
    <div :style="{ display: ['-webkit-box', '-ms-flexbox', 'flex'] }">
        <div :style="{ margin: ['10px'] }">
            <h4>Common Features</h4>
            <h6>Manner features</h6>
            <div v-for="f in out.common.manner" :key="f">{{ f }}</div>
            <h6>Laryngeal features</h6>
            <div v-for="f in out.common.lar" :key="f">{{ f }}</div>
            <h6>Place features</h6>
            <div v-for="f in out.common.place" :key="f">{{ f }}</div>
            <h6>Other features</h6>
            <div v-for="f in out.common.other" :key="f">{{ f }}</div>
        </div>
        <div :style="{ margin: ['10px'] }">
            <h4>Distinctive Features</h4>
            <h6>Manner features</h6>
            <div v-for="f in out.distinctive.manner" :key="f">{{ f }}</div>
            <h6>Laryngeal features</h6>
            <div v-for="f in out.distinctive.lar" :key="f">{{ f }}</div>
            <h6>Place features</h6>
            <div v-for="f in out.distinctive.place" :key="f">{{ f }}</div>
            <h6>Other features</h6>
            <div v-for="f in out.distinctive.other" :key="f">{{ f }}</div>
        </div>
    </div>
</template>

<script setup async>
import { ref, watch } from 'vue'

const mannerStr = "syllabic consonantal sonorant continuant delayed_release approximant tap trill nasal";
const larStr = "voice glottis";
const placeStr = "labial round labiodental coronal anterior distributed strident lateral dorsal high low front back tense";

let smb = ref();
let out = ref({ common: { manner: [], lar: [], place: [], other: [] }, distinctive: { manner: [], lar: [], place: [], other: [] } });
const contain = (f, req) => {
    return req.find(pf => f.includes(pf)) !== undefined;
}
const update = () => {
    const requestOptions = {
        method: 'POST',
        body: smb.value, mode: 'cors',
        headers: {
            "Content-Type": "text/plain",
            "Accept": "*/*",
        },
    };
    fetch("https://api-ph.foundry.owlbeardm.com/api/features/common", requestOptions)
        .then(response => response.json(), err => out.value = "")
        .then(data => {
            const cmn_res = data
                .common
                .split(" ")
                .reduce((res, f) => {
                    if (contain(f, mannerStr.split(" ")))
                        res.manner.push(f);
                    else if (contain(f, larStr.split(" ")))
                        res.lar.push(f);
                    else if (contain(f, placeStr.split(" ")))
                        res.place.push(f);
                    else
                        res.other.push(f);
                    return res;
                }, { manner: [], lar: [], place: [], other: [] });
            const dst_res = data
                .distinctive
                .split(" ")
                .reduce((res, f) => {
                    if (contain(f, mannerStr.split(" ")))
                        res.manner.push(f);
                    else if (contain(f, larStr.split(" ")))
                        res.lar.push(f);
                    else if (contain(f, placeStr.split(" ")))
                        res.place.push(f);
                    else
                        res.other.push(f);
                    return res;
                }, { manner: [], lar: [], place: [], other: [] });
            out.value = {};
            out.value.common = cmn_res;
            out.value.distinctive = dst_res;
        });
}
</script>
