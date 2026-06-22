#!/usr/bin/env node
function featureB() {
    console.log("Hello from Feature B!");
}

if (require.main === module) {
    featureB();
}
