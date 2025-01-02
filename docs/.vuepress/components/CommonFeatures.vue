<template>
    <input type="text" :id="symbols" v-model="smb" @update:model-value="update('onback', picked)" />
    <h6>Manner features</h6>
    <div v-for="f in out.manner" :key="f">{{ f }}</div>
    <h6>Laryngeal features</h6>
    <div v-for="f in out.lar" :key="f">{{ f }}</div>
    <h6>Place features</h6>
    <div v-for="f in out.place" :key="f">{{ f }}</div>
    <h6>Other features</h6>
    <div v-for="f in out.other" :key="f">{{ f }}</div>
</template>

<script setup async>
import { ref, watch } from 'vue'
let smb = ref();
let out = ref({ manner: [], lar: [], place: [], other: [] });
const contain = (f, req) => {
    return req.find(pf => f.includes(pf)) !== undefined;
}
const update = () => {
    const requestOptions = {
        method: 'POST',
        body: smb.value,
    };
    fetch("http://localhost:3003/api/features/common", requestOptions)
        .then(response => response.json(), err => out.value = "")
        .then(data => {
            const res = data
                .features
                .split(" ")
                .reduce((res, f) => {
                    if (contain(f, "syllabic consonantal sonorant continuant delayed_release approximant tap trill nasal".split(" ")))
                        res.manner.push(f);
                    else if (contain(f, "voice glottis".split(" ")))
                        res.lar.push(f);
                    else if (contain(f, "labial round labiodental coronal anterior distributed strident lateral dorsal high low front back tense".split(" ")))
                        res.place.push(f);
                    else
                        res.other.push(f);
                    return res;
                }, { manner: [], lar: [], place: [], other: [] });
            out.value = res;
        });
}
</script>
