<template>
    <input type="text" :id="symbols" :value="smb" v-model="smb"  @update:model-value="update('onback', picked)"/>
    <h5>Manner features</h5>
    <div v-for="f in out.manner" :key="f">{{f}}</div>
    <h5>Laryngeal features</h5>
    <div v-for="f in out.lar" :key="f">{{f}}</div>
    <h5>Place features</h5>
    <div v-for="f in out.place" :key="f">{{f}}</div>
    <h5>Other features</h5>
    <div v-for="f in out.other" :key="f">{{f}}</div>
</template>

<script setup async>
    import { ref, watch } from 'vue'
    let smb = ref();
    let out = ref({manner:[],lar:[],place:[],other:[]});
    const contain=(f,req) => {
        console.log(req, f);
        return req.find(pf => f.includes(pf)) !== undefined;
    }
    const update = () => {
        const requestOptions = {
            method: 'POST',
            body: smb.value,
        };
        const response = fetch("http://localhost:3003/api/features/common", requestOptions)
        .then(response => response.json(), err => out.value = "")
        .then(data =>{ 
            console.log(data);
            const values = data.features.split(" ");
            const manner=values.filter(f=>contain(f,"syllabic consonantal sonorant continuant delayed_release approximant tap trill nasal".split(" ")));
            const lar=values.filter(f=>contain(f,"voice glottis".split(" ")));
            const place=values.filter(f=>contain(f,"labial round labiodental coronal anterior distributed strident lateral dorsal high low front back tense".split(" ")));
            out.value = {
                manner,
                lar,
                place,
                other:values.filter(f=>!contain(f,manner) && !contain(f,lar) && !contain(f,place))
            };
            // out.value.manner = values.filter(f=>contain(f,"".split(" ")));
            // console.log( values.filter(f=>contain(f,"".split(" "))));
            // out.value.lar = values;
            // out.value.place = values;
            // out.value.manner = values;
        });
    }
</script>
