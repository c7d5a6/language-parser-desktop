<template>
    <div class="f-mar">
        <input :style="{ margin: ['10px'] }" type="text" :id="symbols" v-model="smb"
            @update:model-value="update('onback', picked)" />
    </div>
    <div class="f-cont">
        <table>
            <thead>
                <tr>
                    <th>
                        <h4>Common Features</h4>
                    </th>
                    <th>
                        <h4>Distinctive Features</h4>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="2">
                        <b>Manner features</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div v-for="f in out.common.manner" :key="f">{{ f }}</div>
                    </td>
                    <td>
                        <div v-for="f in out.distinctive.manner" :key="f">{{ f }}</div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <b>Laryngeal features</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div v-for="f in out.common.lar" :key="f">{{ f }}</div>
                    </td>
                    <td>
                        <div v-for="f in out.distinctive.lar" :key="f">{{ f }}</div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <b>Place features</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div v-for="f in out.common.place" :key="f">{{ f }}</div>
                    </td>
                    <td>
                        <div v-for="f in out.distinctive.place" :key="f">{{ f }}</div>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <b>Other features</b>
                    </td>
                </tr>
                <tr>
                    <td>
                        <div v-for="f in out.common.other" :key="f">{{ f }}</div>
                    </td>
                    <td>
                        <div v-for="f in out.distinctive.other" :key="f">{{ f }}</div>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <Version />
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
    if (!smb.value) {
        out.value = { common: { manner: [], lar: [], place: [], other: [] }, distinctive: { manner: [], lar: [], place: [], other: [] } };
        return;
    }
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
<style>
.f-cont {
    display: flex;
    margin-bottom: 20px;
}

.f-mar {
    margin: 10px;
}
</style>
