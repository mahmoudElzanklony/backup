<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class OrderResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
          'id'=>$this->id,
          'city'=>$this->city,
          'region'=>$this->region,
          'street'=>$this->street,
          'address'=>$this->address,
          'house_number'=>$this->house_number,
          'coordinates'=>$this->coordinates,
          'status'=>$this->status,
          'note'=>$this->note != null ? (auth()->user()->roleName() == 'client' ? json_decode($this->note,true)['client']:json_decode($this->note,true)) :$this->note,
          'user'=>UserResource::make($this->whenLoaded('user')),
          'rate'=>OrderRateResource::make($this->whenLoaded('rate')),
          'items'=>OrderItemsResource::collection($this->whenLoaded('items')),
          'tracking'=>OrderStatusResource::collection($this->whenLoaded('statues')),
          'coupon_order'=>OrderCouponResource::make($this->whenLoaded('coupon_order')),
          'payment'=>PaymentResource::make($this->whenLoaded('payment')),
          'created_at'=>$this->created_at->format('Y-m-d H:i:s')
        ];
    }
}
