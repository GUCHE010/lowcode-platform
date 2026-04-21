<template>
  <el-dialog title="选择图标" v-model="dialogVisible" width="800px">
    <div class="icon-search">
      <el-input v-model="searchText" placeholder="搜索图标名称" clearable>
        <template #prefix>
          <el-icon><Search /></el-icon>
        </template>
      </el-input>
    </div>
    <div class="icon-list">
      <div
        v-for="icon in filteredIcons"
        :key="icon"
        class="icon-item"
        :class="{ active: selectedIcon === icon }"
        @click="handleSelect(icon)"
      >
        <el-icon :size="24">
          <component :is="icon" />
        </el-icon>
        <span class="icon-name">{{ icon }}</span>
      </div>
    </div>
    <template #footer>
      <el-button @click="dialogVisible = false">取消</el-button>
      <el-button type="primary" @click="handleConfirm">确定</el-button>
    </template>
  </el-dialog>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Search } from '@element-plus/icons-vue'

const dialogVisible = ref(false)
const searchText = ref('')
const selectedIcon = ref('')
const emit = defineEmits(['select'])

const elementPlusIcons = [
  'Add', 'AddressBook', 'AlarmClock', 'Apple', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'ArrowUp',
  'Avatar', 'Back', 'Baseball', 'Basketball', 'Bell', 'BellFilled', 'Bottom', 'Bowl', 'Box', 'Briefcase',
  'Browser', 'Brush', 'BrushFilled', 'Building', 'Bulb', 'Calendar', 'Camera', 'CameraFilled', 'CaretBottom',
  'CaretLeft', 'CaretRight', 'CaretTop', 'Cellphone', 'ChatDotRound', 'ChatDotSquare', 'ChatLineRound',
  'ChatLineSquare', 'ChatRound', 'ChatSquare', 'Check', 'CheckCircle', 'CheckCircleFilled', 'Checked',
  'Cherry', 'Chicken', 'CircleCheck', 'CircleCheckFilled', 'CircleClose', 'CircleCloseFilled', 'CirclePlus',
  'CirclePlusFilled', 'Clock', 'Close', 'CloseBold', 'Cloudy', 'Coffee', 'Coin', 'ColdDrink', 'Collection',
  'CollectionTag', 'Comment', 'Compass', 'Connection', 'Coordinate', 'CopyDocument', 'Cpu', 'CreditCard',
  'Crop', 'CrystalDrink', 'DArrowLeft', 'DArrowRight', 'DCaret', 'DataAnalysis', 'DataBoard', 'DataLine',
  'Delete', 'DeleteFilled', 'DeleteLocation', 'Dessert', 'Discount', 'Dish', 'DishDot', 'Document',
  'DocumentAdd', 'DocumentChecked', 'DocumentCopy', 'DocumentDelete', 'DocumentRemove', 'Download', 'Drizzling',
  'Edit', 'EditPen', 'ElementPlus', 'Expand', 'Failed', 'FastMoving', 'Film', 'Filter', 'Finished',
  'FirstAidKit', 'Fish', 'Flag', 'Fold', 'Folder', 'FolderAdd', 'FolderChecked', 'FolderDelete', 'FolderOpened',
  'FolderRemove', 'Food', 'Football', 'ForkSpoon', 'Fries', 'FullScreen', 'Ghost', 'Goblet', 'GobletFull',
  'GobletSquare', 'Goods', 'Grape', 'Grid', 'Grid4x4', 'Guide', 'Hamburger', 'Handbag', 'Headset',
  'Help', 'HelpFilled', 'Hide', 'Histogram', 'Hot', 'House', 'IceCream', 'IceCreamRound', 'IceCreamSquare',
  'IceDrink', 'IceTea', 'InfoFilled', 'Iphone', 'Key', 'KnifeFork', 'Lightning', 'Link', 'List',
  'Loading', 'Location', 'LocationFilled', 'LocationInformation', 'Lock', 'Lollipop', 'Management',
  'MapLocation', 'Mars', 'Maximize', 'Menu', 'Message', 'MessageBox', 'Mic', 'Microphone', 'MilkTea',
  'Minimize', 'Minus', 'Money', 'Monitor', 'Moon', 'MoonNight', 'More', 'MoreFilled', 'MostlyCloudy',
  'Mouse', 'MouseFilled', 'Mug', 'Mute', 'MuteNotification', 'NoSmoking', 'Notebook', 'Notification',
  'Odometer', 'OfficeBuilding', 'OnlyInput', 'Operation', 'Opportunity', 'Orange', 'Paperclip', 'Parking',
  'Payment', 'Phone', 'PhoneFilled', 'Picture', 'PictureFilled', 'PictureRounded', 'PieChart', 'Place',
  'Platform', 'Plus', 'Pointer', 'Position', 'Postcard', 'Pouring', 'Present', 'PriceTag', 'Printer',
  'Promotion', 'PushNotification', 'Quality', 'Rank', 'Reading', 'ReadingLamp', 'Refresh', 'Refrigerator',
  'Remove', 'RemoveFilled', 'Right', 'Ring', 'RotateLeft', 'RotateRight', 'RoundedCorner', 'RoundClose',
  'RoundCheck', 'SaltPepper', 'School', 'Score', 'Search', 'Select', 'Sell', 'SemiSelect', 'Service',
  'SetUp', 'Setting', 'Share', 'Ship', 'Shop', 'ShoppingBag', 'ShoppingCart', 'Show', 'Shrimp', 'Signal',
  'SignPost', 'Size', 'Slash', 'Slider', 'Soccer', 'SoldOut', 'Sort', 'Souvenir', 'Stamp', 'Star',
  'StarFilled', 'Strawberry', 'SuccessFilled', 'Sugar', 'Suitcase', 'Sunny', 'Sunrise', 'Sunset',
  'Switch', 'SwitchButton', 'TableLamp', 'Ticket', 'Tickets', 'Timer', 'ToiletPaper', 'Tools', 'Top',
  'TopLeft', 'TopRight', 'TrendCharts', 'Trophy', 'TrophyBase', 'TurnOff', 'Umbrella', 'Underline',
  'Unlock', 'Upload', 'UploadFilled', 'Van', 'VideoCamera', 'VideoCameraFilled', 'View', 'Vip', 'Vkontakte',
  'Wallet', 'Warning', 'WarningFilled', 'Watch', 'Watermelon', 'WindPower', 'ZoomIn', 'ZoomOut'
]

const filteredIcons = computed(() => {
  if (!searchText.value) {
    return elementPlusIcons
  }
  return elementPlusIcons.filter(icon =>
    icon.toLowerCase().includes(searchText.value.toLowerCase())
  )
})

const open = (currentIcon?: string) => {
  selectedIcon.value = currentIcon || ''
  dialogVisible.value = true
}

const handleSelect = (icon: string) => {
  selectedIcon.value = icon
}

const handleConfirm = () => {
  emit('select', selectedIcon.value)
  dialogVisible.value = false
}

defineExpose({ open })
</script>

<style scoped>
.icon-search {
  margin-bottom: 16px;
}
.icon-list {
  display: grid;
  grid-template-columns: repeat(8, 1fr);
  gap: 8px;
  max-height: 400px;
  overflow-y: auto;
}
.icon-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 10px 5px;
  border: 1px solid #e8e8e8;
  border-radius: 4px;
  cursor: pointer;
  transition: all 0.2s;
}
.icon-item:hover {
  border-color: #409eff;
  background-color: #f0f7ff;
}
.icon-item.active {
  border-color: #409eff;
  background-color: #409eff;
  color: #fff;
}
.icon-name {
  margin-top: 4px;
  font-size: 12px;
  text-align: center;
  word-break: break-all;
}
</style>
