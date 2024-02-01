from rest_framework import serializers
from Tom.models import SchedulingTasks

class SchedulingSerializer(serializers.ModelSerializer):
    user = serializers.CharField(max_length = 20)
    task = serializers.CharField(max_length = 20)
    scheduled_id = serializers.IntegerField()
    scheduled_time = serializers.IntegerField()

    class Meta:
        model = SchedulingTasks
        fields = ("user", "task", "scheduled_id", "scheduled_time")