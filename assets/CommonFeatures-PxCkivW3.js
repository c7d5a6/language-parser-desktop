import{f as b,o as r,c as l,a as s,g as F,v as S,F as i,h as d,i as C,t as m}from"./app-DInHoo_q.js";import{_ as O}from"./plugin-vue_export-helper-DlAUqK2U.js";const f="syllabic consonantal sonorant continuant delayed_release approximant tap trill nasal",k="voice glottis",g="labial round labiodental coronal anterior distributed strident lateral dorsal high low front back tense",w={__name:"CommonFeatures",setup(h,{expose:t}){t();let v=b(),n=b({common:{manner:[],lar:[],place:[],other:[]},distinctive:{manner:[],lar:[],place:[],other:[]}});const u=(p,c)=>c.find(y=>p.includes(y))!==void 0,e={mannerStr:f,larStr:k,placeStr:g,get smb(){return v},set smb(p){v=p},get out(){return n},set out(p){n=p},contain:u,update:()=>{const p={method:"POST",body:v.value,mode:"cors",headers:{"Content-Type":"text/plain",Accept:"*/*"}};fetch("https://api-ph.foundry.owlbeardm.com/api/features/common",p).then(c=>c.json(),c=>n.value="").then(c=>{const y=c.common.split(" ").reduce((a,o)=>(u(o,f.split(" "))?a.manner.push(o):u(o,k.split(" "))?a.lar.push(o):u(o,g.split(" "))?a.place.push(o):a.other.push(o),a),{manner:[],lar:[],place:[],other:[]}),x=c.distinctive.split(" ").reduce((a,o)=>(u(o,f.split(" "))?a.manner.push(o):u(o,k.split(" "))?a.lar.push(o):u(o,g.split(" "))?a.place.push(o):a.other.push(o),a),{manner:[],lar:[],place:[],other:[]});n.value={},n.value.common=y,n.value.distinctive=x})},ref:b,watch:C};return Object.defineProperty(e,"__isScriptSetup",{enumerable:!1,value:!0}),e}},P={class:"f-mar"},B=["id"],D={class:"f-cont"},L={class:"f-mar"},M={class:"f-mar"};function T(h,t,v,n,u,_){return r(),l(i,null,[s("div",P,[F(s("input",{style:{margin:["10px"]},type:"text",id:h.symbols,"onUpdate:modelValue":[t[0]||(t[0]=e=>n.smb=e),t[1]||(t[1]=e=>n.update("onback",h.picked))]},null,8,B),[[S,n.smb]])]),s("div",D,[s("div",L,[t[2]||(t[2]=s("h4",null,"Common Features",-1)),t[3]||(t[3]=s("h6",null,"Manner features",-1)),(r(!0),l(i,null,d(n.out.common.manner,e=>(r(),l("div",{key:e},m(e),1))),128)),t[4]||(t[4]=s("h6",null,"Laryngeal features",-1)),(r(!0),l(i,null,d(n.out.common.lar,e=>(r(),l("div",{key:e},m(e),1))),128)),t[5]||(t[5]=s("h6",null,"Place features",-1)),(r(!0),l(i,null,d(n.out.common.place,e=>(r(),l("div",{key:e},m(e),1))),128)),t[6]||(t[6]=s("h6",null,"Other features",-1)),(r(!0),l(i,null,d(n.out.common.other,e=>(r(),l("div",{key:e},m(e),1))),128))]),s("div",M,[t[7]||(t[7]=s("h4",null,"Distinctive Features",-1)),t[8]||(t[8]=s("h6",null,"Manner features",-1)),(r(!0),l(i,null,d(n.out.distinctive.manner,e=>(r(),l("div",{key:e},m(e),1))),128)),t[9]||(t[9]=s("h6",null,"Laryngeal features",-1)),(r(!0),l(i,null,d(n.out.distinctive.lar,e=>(r(),l("div",{key:e},m(e),1))),128)),t[10]||(t[10]=s("h6",null,"Place features",-1)),(r(!0),l(i,null,d(n.out.distinctive.place,e=>(r(),l("div",{key:e},m(e),1))),128)),t[11]||(t[11]=s("h6",null,"Other features",-1)),(r(!0),l(i,null,d(n.out.distinctive.other,e=>(r(),l("div",{key:e},m(e),1))),128))])])],64)}const q=O(w,[["render",T],["__file","CommonFeatures.vue"]]);export{q as default};
