import QtQuick 2.0
import QtQml 2.12

QtObject {

    function delay(delayTime, cb) {
        timer.interval = delayTime;
        timer.repeat = false;
        timer.triggered.connect(cb);
        timer.start();
    }

    function getCountVisiblePopups()
    {
        var count = networkList.width/item_width
        return Math.floor(count)
    }

    function percentToRatio(text)
    {
        if(app.getNodeMode() === 0) //local
        {
            var percent = parseFloat(text)
            if(isNaN(percent) || percent < 0 || percent > 150)
            {
                console.warn("Percent of processed is wrong:", text)
                percent = 0.0
            }
            return percent / 100.0
        }
        else
            return 1.0
    }
}
